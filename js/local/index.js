var PER_PAGE_CNT = 10; //每页显示个数

function back_index() 
{
	window.location.href = "index.html";
}

/* @brief 获取url参数
*/
(function ($) {
	$.getUrlParam = function (name) {
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
		var r = window.location.search.substr(1).match(reg);
		if (r != null) return unescape(r[2]); return null;
	}
})(jQuery);

function formatDate(now) { 
	var year=now.getYear() + 1900; 
	var month=now.getMonth()+1; 
	var date=now.getDate(); 
	var hour=now.getHours(); 
	var minute=now.getMinutes(); 
	var second=now.getSeconds(); 
	return year+"-"+month+"-"+date+" "+hour+":"+minute+":"+second; 
} 

function more(id) 
{
	$.post("src/dispatcher.php", {
		"func" : "get_one", 
		"id" : id
	}, function(data) {
		var content = "<p class='blog-post-title text-center'>" + data[1] + "</p>";
		content += "<p class='text-right blog-post-meta'>发布时间:" + data[5];
		var type = $.cookies.get('g_blog_sub_menu')[parseInt(data[3] / 100)];
		content += " 类型:" + type[data[3]];
		content += " 来源:" + $.cookies.get("g_blog_from_type")[data[4]];
		content += "</p><hr/>";
		content += "<p class='blog-post-content'>" + data[2] + "</p>";
		$('#content').html(content);
	}, "json");
}


function switch_real_page(page) 
{
	var view_type = $.cookies.get('view_type');
	if (view_type == 0) {
		list(page);
	} else if (view_type == 2) {
		search_by_type(view_type);
	}
}

function prev_page(page)
{
	if (page <= 1) {
		return ;
	}

	var start = page - 5;
	switch_real_page(start);
}

function next_page(page)
{
	total = $.cookies.get('info_total');
	var max_page = Math.ceil(total / PER_PAGE_CNT);
	if (page + 5 >= max_page) {
		return ;
	}

	start = page + 5;
	switch_real_page(start);
}

function switch_page(page)
{
	switch_real_page(page);
}

function get_page_html(page, total)
{
	//var start = (page - 1) * PER_PAGE_CNT + 1;
	var start = page % 5 + (parseInt(page / 5)) * 5;
	var page_str = "<p class='blog-pager'><nav><ul class='pager'><li><a href='#' aria-label='Previous' onclick='prev_page(" + page + ")'><span aria-hidden='true'>&laquo;</span></a></li>";
	var max_page = Math.ceil(total / PER_PAGE_CNT);

	for (var i = page, j = 0; i <= max_page && j < 5; ++i, ++j) {
		page_str += "<li id='page" + i + "'><a href='#' onclick='switch_page(" + i + ")'>" + i + "</a></li>";
	}

	page_str += "<li><a href='#' aria-label='Next' onclick='next_page(" + page + ")'><span aria-hidden='true'>&raquo;</span></a></li></ul></nav></p>";

	return page_str;
}

function list(page) 
{
	var start = (page - 1) * PER_PAGE_CNT + 1;
	$.post("src/dispatcher.php", {
		"func": "list_pager", 
		"start": start,
		"end" : PER_PAGE_CNT
	}, function(ret){
		if (start == 1) {
			var total = ret['total'];
			$.cookies.set("info_total", total);
		}

		var html_str = "";
		var data = ret['data'];
		var menu = $.cookies.get('g_blog_menu');
		var submenu = $.cookies.get('g_blog_sub_menu');
		for (var key in data) {
			var id = data[key][0];
			var title = data[key][2];
			var type = data[key][1];
			var pubtime = parseInt(data[key][3]);
			var from_type = data[key][4];
			var content = data[key][5];
			
			var tmp = "<div class='blog-post'>";
			tmp += "<h5 class='blog-post-title'>" + title +"</h5>";
			tmp += "<p class='blog-post-meta'>" + formatDate(new Date(pubtime * 1000)) + " by <a href='#'>xxmn</a></p>";
			tmp += "<p class='blog-post-content'>" + content + "</p>";
			tmp += "<p class='blog-post-more'><a href='#' onclick='more(" + id + ")'>查看[" + title + "]全文...</a></p>"
			tmp += "<hr></div>";
			html_str += tmp;
		}

		var page_html = get_page_html(page, $.cookies.get('info_total'));
		html_str += page_html;
		$('#content').html(html_str);

		$("#pager li").removeClass('active');
		$('#page'+page).addClass('active');
	},"json");	
}

function get_content(id)
{
	$.post("src/dispatcher.php", {
		"func" : "get_one", 
	"id" : id
	}, function(data) {
		var content = "<center><h3>" + data[1] + "</h3></center>";
		content += "<p class='text-right'>发布时间: 来源: 作者: </p>";
		content += "<hr/>";
		content += "<p class='blog-post-content'>" + data[2] + "</p>";
		$('#submenu_title').html(content);
	}, "json");
}

function init_mark() 
{
	var data = $.cookies.get("g_blog_sub_menu");
	var mark_str = "<h4>标签</h4>";
	for (var i in data) {
		for (var j in data[i]) {
			mark_str += "<a href='index.html?action=type&type="+j+"'>" + data[i][j] + "</a> "
		}
	}

	mark_str += "</div>";

	$('#mark').html(mark_str);
}

function search() 
{
	if ($('#search_key').val() == "") {
		return ;
	}

	$.post("src/dispatcher.php", {
		"func" : "search_by_key",
	"key" : $('#search_key').val()
	}, function(ret) {
		var data = ret["data"];
		var html_str="";
		for (var key in data) {
			var id = data[key][0];
			var title = data[key][2];
			var type = data[key][1];
			var pubtime = parseInt(data[key][3]);
			var from_type = data[key][4];
			var content = data[key][5];

			var tmp = "<div class='blog-post'>";
			tmp += "<h5 class='blog-post-title'>" + title +"</h5>";
			tmp += "<p class='blog-post-meta'>" + formatDate(new Date(pubtime * 1000)) + " by <a href='#'>xxmn</a></p>";
			tmp += "<p>" + content + "</p>";
			tmp += "<p class='blog-post-more'><a href='#' onclick='more(" + id + ")'>查看[" + title + "]全文...</a></p>"
		tmp += "<hr></div>";
	html_str += tmp;
		}

		$('#content').html(html_str);
	}, "json");
}

function backTop() 
{
	//首先将#back-to-top隐藏
	$("#back-to-top").hide();
	//当滚动条的位置处于距顶部100像素以下时，跳转链接出现，否则消失
	$(function() {
		$(window).scroll(function() {
			if ($(window).scrollTop() > 100) {
				$("#back-to-top").fadeIn(1500);
			} else {
				$("#back-to-top").fadeOut(1500);
			}
		});
		//当点击跳转链接后，回到页面顶部位置
		$("#back-to-top").click(function() {
			$('body,html').animate({
				scrollTop: 0
			},
			1000);
			return false;
		});
	});
}

function search_by_type(type, page) 
{
	var start = (page - 1) * PER_PAGE_CNT + 1;
	$.post("src/dispatcher.php", {
		"func": "search_by_type", 
		"start": start,
		"end" : PER_PAGE_CNT,
		"type" : type
	}, function(ret){
		if (start == 1) {
			var total = ret['total'];
			$.cookies.set("info_total", total);
		}

		var html_str = "";
		var data = ret['data'];
		var menu = $.cookies.get('g_blog_menu');
		var submenu = $.cookies.get('g_blog_sub_menu');
		for (var key in data) {
			var id = data[key][0];
			var title = data[key][2];
			var type = data[key][1];
			var pubtime = parseInt(data[key][3]);
			var from_type = data[key][4];
			var content = data[key][5];

			var tmp = "<div class='blog-post'>";
			tmp += "<h5 class='blog-post-title'>" + title +"</h5>";
			tmp += "<p class='blog-post-meta'>" + formatDate(new Date(pubtime * 1000)) + " by <a href='#'>xxmn</a></p>";
			tmp += "<p class='blog-post-content'>" + content + "</p>";
			tmp += "<p class='blog-post-more'><a href='#' onclick='more(" + id + ")'>查看[" + title + "]全文...</a></p>"
				tmp += "<hr></div>";
			html_str += tmp;
		}

		var page_html = get_page_html(page, $.cookies.get('info_total'));
		html_str += page_html;
		$('#content').html(html_str);

		$("#pager li").removeClass('active');
		$('#page'+page).addClass('active');
	},"json");	

}

$(document).ready(function(){
	backTop();
	$.post("src/dispatcher.php", {
		"func" : "get_def_vals"
	}, function(data) {
		$.cookies.set("g_blog_menu", data['menu']);	
		$.cookies.set("g_blog_sub_menu", data['sub_menu']);	
		$.cookies.set("g_blog_from_type", data['from_type']);	

		var action = $.getUrlParam("action");
		if (action == null) {
			$.cookies.set("view_type", 0);
			switch_page(1);
		} else {
			$.cookies.set("view_type", $.getUrlParam("type"));
			search_by_type($.getUrlParam("type"), 1);
		}
		init_mark();	
	}, "json");
});


