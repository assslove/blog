<?php

require_once("log.php");

class MysqlCli {
	private $host;
	private $username;
	private $passwd;

	private $conn;
	private $db;

	public function __construct() {
		$this->host = "localhost";
		$this->username = "root";
		$this->passwd = "8459328";
		$this->db = "blog";
	}

	public function __destruct() {
		mysql_close($this->conn);
	}

	public function connect() {
		$this->conn = mysql_connect($this->host, $this->username, $this->passwd);
		if (!$this->conn) {
			die('could not connect:'.mysql_error());
		}
		mysql_select_db($this->db, $this->conn);
		mysql_query("set names utf8");
	}

	public function close() {
		mysql_close($this->conn);
	}

	public function exec_query($sql) {
		writelog($sql);
		return mysql_query($sql, $this->conn);
	}


};
?>
