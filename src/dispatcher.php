<?php

require_once('mysql_cli.php');
require_once('define.php');
require_once('log.php');

$users = array (
	array("admin", "admin"),
	array("test", "test"),
);

function login() 
{
	session_start();
	global $users;

	$is_valid = 0;
	$size = count($users);
	for ($i = 0; $i < $size ; ++$i) {
		if ($users[$i][0] == $_POST["name"] && $users[$i][1] == $_POST["password"]) {
			$is_valid = 1;
			$_SESSION["name"] = $_POST["name"];
			break;
		}
	}

	echo $is_valid;
}

function checkUser() 
{
	session_start();
	if (isset($_SESSION["name"])) {
		echo 1; 
	} else {
		echo 0; 
	}
}

function leave() {
	session_start();
	unset($_SESSION["name"]);
}


/* @brief 列出所有项
 */
function list_all() 
{
	global $menu;
	global $sub_menu;
	$html="<table class='table table-hover table-condensed'><thead><tr><th>#</th><th>类型</th><th>来源</th><th>标题</th><th>时间</th><th>操作</th></tr></thead><tbody>";
	$mc = new MysqlCli();
	$mc->connect();
	$result = $mc->exec_query("select id, type, title, pub_time, from_type from t_info order by pub_time desc");
	$from_types = array("原创", "转载");
	if ($result) {
		while ($row = mysql_fetch_array($result)) {
			$type = $menu[$row['type'] / 100][1] . "/" . $sub_menu[$row['type']/100][$row['type']];
			$html .= "<tr><th scope='row'>".$row['id']."</th><td>".$type."</td><td>".$from_types[$row['from_type']]."</td><td>".$row['title']."</td><td>".date('Y-m-d H:i',$row['pub_time'])."</td><td>";
			$html .="<input class='btn btn-primary' type='button' onclick='modify_one(".$row['id'].")' value='修改'/> ";
			$html .="<input class='btn btn-primary' type='button' onclick='del_one(".$row['id'].")' value='删除'/> ";
			$html .="<input class='btn btn-primary' type='button' onclick='view_one(".$row['id'].")' value='预览'/>";
			$html .="</td></tr>";
		}
		mysql_free_result($result);
	}
	$html .="</tbody></table>";
	echo $html;
}

/* @brief 删除一项数据
 */
function del_one()
{
	$id = $_POST['id'];
	$mc = new MysqlCli();
	$mc->connect();
	$result = $mc->exec_query("delete from t_info where id=".$id);
	if (!$result) {
		echo "删除失败";
		return ;
	}

	return ;
}

function save()
{
	$id = $_POST['id'];
	$type = $_POST['type'];
	$title = $_POST['title'];
	$content = $_POST['content'];
	$from_type= $_POST['from_type'];

	$mc = new MysqlCli();
	$mc->connect();
	$sql = "";
	if ($id != 0) {
		$sql = "update t_info set type=".$type.", title='".$title."',content='".mysql_escape_string($content)."',pub_time="
			.time().", from_type=".$from_type." where id=".$id;
	} else {
		$sql = "insert into t_info(type,title,content,pub_time,author, from_type) values(".$type.",'".$title."', '".
			mysql_escape_string($content)."',". time() . ", 'admin', 0)";
	}
	$result = $mc->exec_query($sql);
	if (!$result) {
		echo mysql_error();
	} else {
		echo "1";
	}
}

function get_menu()
{
	global $menu;
	echo json_encode($menu, JSON_UNESCAPED_UNICODE);
}

function get_submenu()
{
	$index = $_POST['index'];
	global $sub_menu;
	echo json_encode($sub_menu[$index], JSON_UNESCAPED_UNICODE);
}

function get_one() 
{
	$id = $_POST['id'];
	$mc = new MysqlCli();
	$mc->connect();
	$result = $mc->exec_query("select * from t_info where id=".$id . " limit 1");
	if (!$result) {
		writelog("get info failed, id=". $id);
		return ;
	}


	$row = mysql_fetch_array($result);
	$ret = array();
	$info = array();
	array_push($info,$id);
	array_push($info,$row['title']);
	array_push($info,$row['content']);
	array_push($info,$row['type']);
	array_push($info,$row['from_type']);
	array_push($info, date('Y-m-d H:i', $row['pub_time']));
	$tmp = $row['pub_time'];
	mysql_free_result($result);
	array_push($ret, $info);

	//前一篇
	$info = array();
	$page = array();
	$result = $mc->exec_query("select id, title from t_info where pub_time > " . $tmp . " order by pub_time asc limit 1");
	if ($result) {
		$row = mysql_fetch_array($result);
		array_push($info,$row["id"]);
		array_push($info,$row['title']);
		mysql_free_result($result);
	} else {
		array_push($info, 0);
	}
	array_push($ret, $info);
	//下一篇
	$info = array();
	$result = $mc->exec_query("select id, title from t_info where pub_time < " . $tmp . " order by pub_time desc limit 1");
	if ($result) {
		$row = mysql_fetch_array($result);
		array_push($info,$row["id"]);
		array_push($info,$row['title']);
		mysql_free_result($result);
	} else {
		array_push($info, 0);
	}
	array_push($ret, $info);

	echo json_encode($ret, JSON_UNESCAPED_UNICODE); 
}

function get_titles()
{
	$type = $_POST['type'];  
	$mc = new MysqlCli();
	$mc->connect();
	$sql = "select id, title, pub_time from t_info where type=".$type ." order by pub_time desc";
	$result = $mc->exec_query($sql);
	if (!$result) {
		writelog("get titles failed, type=". $type);
		return ;
	}

	$ret = array();
	while ($row = mysql_fetch_array($result)) {
		$item = array();
		array_push($item, $row['id'], $row['title'], date('Y-m-d H:i',$row['pub_time']));
		array_push($ret, $item);
	}

	mysql_free_result($result);
	echo json_encode($ret, JSON_UNESCAPED_UNICODE);
}

function get_all_content()
{
	$type = $_POST['type'];  
	$mc = new MysqlCli();
	$mc->connect();
	$sql = "select id, title, pub_time, content from t_info where type=".$type ." order by pub_time desc";
	$result = $mc->exec_query($sql);
	if (!$result) {
		writelog("get titles failed, type=". $type);
		return ;
	}

	$ret = array();
	while ($row = mysql_fetch_array($result)) {
		$item = array();
		array_push($item, $row['id'], $row['title'], date('Y-m-d H:i',$row['pub_time']), $row['content']);
		array_push($ret, $item);
	}

	mysql_free_result($result);
	echo json_encode($ret, JSON_UNESCAPED_UNICODE);
}


function get_content_by_type()
{
	$type = $_POST['type'];
	$mc = new MysqlCli();
	$mc->connect();
	$result = $mc->exec_query("select * from t_info where type=".$type. " limit 1");
	if (!$result) {
		writelog("get info failed, id=". $id);
		return ;
	}

	$row = mysql_fetch_array($result);
	$ret = array();
	array_push($ret,$id);
	array_push($ret,$row['title']);
	array_push($ret,$row['content']);
	array_push($ret,$row['type']);
	mysql_free_result($result);

	echo json_encode($ret, JSON_UNESCAPED_UNICODE); 

}

function search() 
{
	global $menu;
	global $sub_menu;
	$search_title = $_POST['search_title'];
	$html="<table class='table table-hover table-condensed'><thead><tr><th>#</th><th>类型</th><th>来源</th><th>标题</th><th>时间</th><th>操作</th></tr></thead><tbody>";
	$mc = new MysqlCli();
	$mc->connect();
	$result = $mc->exec_query("select id, type, title, pub_time, from_type from t_info where title like '%".mysql_escape_string($search_title)."%' order by pub_time desc");
	$from_types = array("原创", "转载");
	if ($result) {
		while ($row = mysql_fetch_array($result)) {
			$type = $menu[$row['type'] / 100][1] . "/" . $sub_menu[$row['type']/100][$row['type']];
			$html .= "<tr><th scope='row'>".$row['id']."</th><td>".$type."</td><td>".$from_types[$row['from_type']]."</td><td>".$row['title']."</td><td>".date('Y-m-d H:i',$row['pub_time'])."</td><td>";
			$html .="<input class='btn btn-primary' type='button' onclick='modify_one(".$row['id'].")' value='修改'/> ";
			$html .="<input class='btn btn-primary' type='button' onclick='del_one(".$row['id'].")' value='删除'/> ";
			$html .="<input class='btn btn-primary' type='button' onclick='view_one(".$row['id'].")' value='预览'/>";
			$html .="</td></tr>";
		}
		mysql_free_result($result);
	}
	$html .="</tbody></table>";
	echo $html;
}

function list_pager() 
{
	$start = $_POST['start'];
	$end = $_POST['end'];
	$ret = array();

	$mc = new MysqlCli();
	$mc->connect();
	$result = null;
	if ($start == 1) { //第1页的时候获取长度
		$result = $mc->exec_query("select count(*) total from t_info");
		if ($result) {
			$row = mysql_fetch_array($result);
			$ret["total"] = $row['total'];
			mysql_free_result($result);
		}
	}

	$start = $start - 1;
	$result = $mc->exec_query("select id, type, title, pub_time, from_type, LEFT(content, 200)  abstract from t_info order by pub_time desc limit ".$start.",".$end);
	$data = array();
	if ($result) {
		while ($row = mysql_fetch_array($result)) {
			$item = array();
			array_push($item, $row['id']);	
			array_push($item, $row['type']);	
			array_push($item, $row['title']);	
			array_push($item, $row['pub_time']);	
			array_push($item, $row['from_type']);	
			array_push($item, $row['abstract']);	

			array_push($data, $item);
		}
		mysql_free_result($result);
	}
	$ret["data"] = $data;

	echo json_encode($ret, JSON_UNESCAPED_UNICODE);
}

/* @brief 返回默认定义值
 */
function get_def_vals() 
{
	global $menu;
	global $sub_menu;
	global $from_type;

	$ret = array();
	$ret["menu"] = $menu;
	$ret["sub_menu"] = $sub_menu;
	$ret["from_type"] = $from_type;

	echo json_encode($ret, JSON_UNESCAPED_UNICODE);
}

function search_by_key()
{
	$key = $_POST['key'];
	$mc = new MysqlCli();
	$mc->connect();
	$result = null;
	$result = $mc->exec_query("select id, type, title, pub_time, from_type, left(content, 200) abstract from t_info where title like '%".$key."%' order by pub_time desc limit 10");
	$ret = array();
	$data = array();
	if ($result) {
		while ($row = mysql_fetch_array($result)) {
			$item = array();
			array_push($item, $row['id']);	
			array_push($item, $row['type']);	
			array_push($item, $row['title']);	
			array_push($item, $row['pub_time']);	
			array_push($item, $row['from_type']);	
			array_push($item, $row['abstract']);	

			array_push($data, $item);
		}
		mysql_free_result($result);
	}
	$ret["data"] = $data;

	echo json_encode($ret, JSON_UNESCAPED_UNICODE);

}

function dispatch_url()
{

}

function search_by_type()
{
	$start = $_POST['start'];
	$end = $_POST['end'];
	$type = $_POST['type'];
	$ret = array();

	$mc = new MysqlCli();
	$mc->connect();
	$result = null;
	if ($start == 1) { //第1页的时候获取长度
		$result = $mc->exec_query("select count(*) total from t_info where type = " . $type);
		if ($result) {
			$row = mysql_fetch_array($result);
			$ret["total"] = $row['total'];
			mysql_free_result($result);
		}
	}

	$start = $start - 1;
	$result = $mc->exec_query("select id, type, title, pub_time, from_type, LEFT(content, 200)  abstract from t_info where type=".$type." order by pub_time desc limit ".$start.",".$end);
	$data = array();
	if ($result) {
		while ($row = mysql_fetch_array($result)) {
			$item = array();
			array_push($item, $row['id']);	
			array_push($item, $row['type']);	
			array_push($item, $row['title']);	
			array_push($item, $row['pub_time']);	
			array_push($item, $row['from_type']);	
			array_push($item, $row['abstract']);	

			array_push($data, $item);
		}
		mysql_free_result($result);
	}
	$ret["data"] = $data;

	echo json_encode($ret, JSON_UNESCAPED_UNICODE);

}

function backup() 
{
	$result = exec('sh ./sql/bak.sh', $out, $status);
	if ($status == 0) {
		echo "backup success";
	} else {
		echo "backup failed";
	}
}

function publish() 
{
	$result = exec('sh ./sql/publish.sh', $out, $status);
	if ($status == 0) {
		echo "backup success";
	} else {
		echo "backup failed";
	}
}


function dispatch_post() 
{
	$func = $_POST['func'];
	switch ($func) {
	case 'login':
		return login();
	case 'list':
		return list_all();
	case 'del_one':
		return del_one();
	case 'save':
		return save();
	case 'get_menu':
		return get_menu();
	case 'get_submenu':
		return get_submenu();
	case 'get_one':
		return get_one();
	case 'get_titles':
		return get_titles();
	case 'get_all_content':
		return get_all_content();
	case 'get_content_by_type':
		return get_content_by_type();
	case 'search':
		return search();
	case 'list_pager':
		return list_pager();
	case 'get_def_vals':
		return get_def_vals();
	case "checkUser":
		return checkUser();
	case "leave":
		return leave();
	case 'search_by_key':
		return search_by_key();
	case 'search_by_type':
		return search_by_type();
	case "backup":
		return backup();
	case "publish":
		return publish();
	case '2':
		break;
	default:
		writelog("no controller");
	}
}

//协议处理器
if ($_POST['func'] == "") {
	return dispatch_url();
} else {
	return dispatch_post();
}
?>
