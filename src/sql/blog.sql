-- MySQL dump 10.13  Distrib 5.1.73, for redhat-linux-gnu (x86_64)
--
-- Host: 127.5.31.130    Database: blog
-- ------------------------------------------------------
-- Server version	5.5.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `t_info`
--

DROP TABLE IF EXISTS `t_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` smallint(6) NOT NULL COMMENT '类型',
  `title` varchar(256) DEFAULT NULL COMMENT '标题',
  `content` mediumtext COMMENT '内容',
  `pub_time` int(10) unsigned DEFAULT NULL COMMENT '发表时间',
  `author` varchar(64) DEFAULT NULL COMMENT '作者',
  `from_type` tinyint(4) DEFAULT '0' COMMENT '来源',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_info`
--

LOCK TABLES `t_info` WRITE;
/*!40000 ALTER TABLE `t_info` DISABLE KEYS */;
INSERT INTO `t_info` VALUES (5,401,'网络程序C10k问题','地址：<a href=\"http://www.kegel.com/c10k.html\" target=\"_blank\">http://www.kegel.com/c10k.html</a><br>\n[<a href=\"http://www.lwn.net/\">Help save the best Linux news source on the web -- subscribe to Linux Weekly News!</a>]\n<p>It\'s time for web servers to handle ten thousand clients simultaneously, don\'t you think? After all, the web is a big place now.</p>\n<p>And computers are big, too. You can buy a 1000MHz machine with 2 gigabytes of RAM and an 1000Mbit/sec Ethernet card for $1200 or so. Let\'s see - at 20000 clients, that\'s 50KHz, 100Kbytes, and 50Kbits/sec per client. It shouldn\'t take any more horsepower than that to take four kilobytes from the disk and send them to the network once a second for each of twenty thousand clients. (That works out to $0.08 per client, by the way. Those $100/client licensing fees some operating systems charge are starting to look a little heavy!) So hardware is no longer the bottleneck.</p>\n<p>In 1999 one of the busiest ftp sites, cdrom.com, actually handled 10000 clients simultaneously through a Gigabit Ethernet pipe. As of 2001, that same speed is now&nbsp;<a href=\"http://www.senteco.com/telecom/ethernet.htm\">being offered by several ISPs</a>, who expect it to become increasingly popular with large business customers.</p>\n<p>And the thin client model of computing appears to be coming back in style -- this time with the server out on the Internet, serving thousands of clients.</p>\n<p>With that in mind, here are a few notes on how to configure operating systems and write code to support thousands of clients. The discussion centers around Unix-like operating systems, as that\'s my personal area of interest, but Windows is also covered a bit.</p>\n<h2 style=\"color: rgb(0, 0, 0); font-family: \'Times New Roman\'; line-height: normal;\">Contents</h2>\n<ul style=\"color: rgb(0, 0, 0); font-family: \'Times New Roman\'; font-size: medium; line-height: normal;\">\n<li><a href=\"http://www.kegel.com/c10k.html#top\">The C10K problem</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#related\">Related Sites</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#books\">Book to Read First</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#frameworks\">I/O frameworks</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#strategies\">I/O Strategies</a><ol>\n<li><a href=\"http://www.kegel.com/c10k.html#nb\">Serve many clients with each thread, and use nonblocking I/O and&nbsp;<b>level-triggered</b>&nbsp;readiness notification</a><ul>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.select\">The traditional select()</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.poll\">The traditional poll()</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb./dev/poll\">/dev/poll</a>&nbsp;(Solaris 2.7+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.kqueue\">kqueue</a>&nbsp;(FreeBSD, NetBSD)</li>\n</ul>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.edge\">Serve many clients with each thread, and use nonblocking I/O and readiness&nbsp;<b>change</b>&nbsp;notification</a><ul>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.epoll\">epoll</a>&nbsp;(Linux 2.6+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.kevent\">Polyakov\'s kevent</a>&nbsp;(Linux 2.6+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.newni\">Drepper\'s New Network Interface</a>&nbsp;(proposal for Linux 2.6+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.sigio\">Realtime Signals</a>&nbsp;(Linux 2.4+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.sigfd\">Signal-per-fd</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.kqueue\">kqueue</a>&nbsp;(FreeBSD, NetBSD)</li>\n</ul>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#aio\">Serve many clients with each thread, and use asynchronous I/O and completion notification</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#threaded\">Serve one client with each server thread</a><ul>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.linuxthreads\">LinuxThreads</a>&nbsp;(Linux 2.0+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.ngpt\">NGPT</a>&nbsp;(Linux 2.4+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.nptl\">NPTL</a>&nbsp;(Linux 2.6, Red Hat 9)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.freebsd\">FreeBSD threading support</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.netbsd\">NetBSD threading support</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.solaris\">Solaris threading support</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.java\">Java threading support in JDK 1.3.x and earlier</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#1:1\">Note: 1:1 threading vs. M:N threading</a></li>\n</ul>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#kio\">Build the server code into the kernel</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#userspace\">Bring the TCP stack into userspace</a></li>\n</ol>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#comments\">Comments</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#limits.filehandles\">Limits on open filehandles</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#limits.threads\">Limits on threads</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#java\">Java issues</a>&nbsp;[Updated 27 May 2001]</li>\n<li><a href=\"http://www.kegel.com/c10k.html#tips\">Other tips</a><ul>\n<li><a href=\"http://www.kegel.com/c10k.html#zerocopy\">Zero-Copy</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#sendfile\">The sendfile() system call can implement zero-copy networking.</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#writev\">Avoid small frames by using writev (or TCP_CORK)</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#nativethreads\">Some programs can benefit from using non-Posix threads.</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#caching\">Caching your own data can sometimes be a win.</a></li>\n</ul>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#limits.other\">Other limits</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#kernel\">Kernel Issues</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#benchmarking\">Measuring Server Performance</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples\">Examples</a><ul>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.nb.select\">Interesting select()-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.nb./dev/poll\">Interesting /dev/poll-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.nb.epoll\">Interesting epoll-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.nb.kqueue\">Interesting kqueue()-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.nb.sigio\">Interesting realtime signal-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.threaded\">Interesting thread-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.kio\">Interesting in-kernel servers</a></li>\n</ul>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#links\">Other interesting links<br></a></li>\n</ul>\n<p style=\"color: rgb(0, 0, 0); font-family: \'Times New Roman\'; font-size: medium; line-height: normal;\"></p>',1429540487,'admin',0),(7,401,'零费用建站','<p>提供商： OpenShift + TK + DNSPOT</p><p>OpenShift：提供主机空间， 二级域名 不过国内屏蔽，只能访问https，速度够慢， 提供git代码提交， 免费一年<br></p><p>TK：免费一级域名，可以转发到OpenShift申请的二级域名<br></p><p>DNSPOT：dns加速，设置CNAME到二级域名，并更改TK的NS<br></p>',1429518081,'admin',0),(8,2001,'书单','<div>unix环境高级编程</div>\n<div>unix网络编程</div>\n<div>unix进程间通信</div>\n<div>tcp/ip详解卷1</div>\n<div><br></div>\n<div>高性能Mysql</div>\n<div>mysql优化</div>\n<div>Redis设计与实现</div>\n<div><br></div>\n<div>操作系统</div>\n<div>编译链接</div>\n<div>linux设计与实现</div>\n<div>shell入门与精通</div>\n<div><br></div>\n<div>c++primer</div>\n<div>stl源码剖析</div>\n<div>effective c++</div>\n<div>c++对象模型</div>\n<div>Python/php/Shell</div>\n<div><br></div>\n<div>数据结构</div>\n<div>剑指offer</div>\n<div>算法导论</div>\n<div><br></div>\n<div>分布式</div>\n<div>性能测试</div>\n<div>负载均衡</div>\n<div>大数据</div>\n<div>服务器性能</div>\n<div><br></div>\n<div>源码阅读</div>\n<div>Linux内核</div>\n<div>Redis</div>\n<div>libevent</div>\n<div>nginx</div>\n<div>memcached</div>\n<div>chrome</div>\n<div>leveldb</div>\n<div>webbench</div>\n<div>tinyhttpd</div>\n<div>cJson</div>\n<div>lua</div>\n<div>sqlite</div>\n<div>unix v6</div>\n<div>protobuf</div>',1429541383,'admin',0),(9,501,'网站性能','<p>本站刚建立，虽然每秒只能响应4-5个请求，但是对于个人博客来说已经足够，免费搭建起来的也不错哦!</p>\n<p><img src=\"img/upload/82161242827b703e6acf9c726942a1e4.png\" style=\"width: 478px; height: 481px;\"></p>',1429581788,'admin',0);
/*!40000 ALTER TABLE `t_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-04-20 22:09:08
