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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_info`
--

LOCK TABLES `t_info` WRITE;
/*!40000 ALTER TABLE `t_info` DISABLE KEYS */;
INSERT INTO `t_info` VALUES (5,401,'网络程序C10k问题','地址：<a href=\"http://www.kegel.com/c10k.html\" target=\"_blank\">http://www.kegel.com/c10k.html</a><br>\n[<a href=\"http://www.lwn.net/\">Help save the best Linux news source on the web -- subscribe to Linux Weekly News!</a>]\n<p>It\'s time for web servers to handle ten thousand clients simultaneously, don\'t you think? After all, the web is a big place now.</p>\n<p>And computers are big, too. You can buy a 1000MHz machine with 2 gigabytes of RAM and an 1000Mbit/sec Ethernet card for $1200 or so. Let\'s see - at 20000 clients, that\'s 50KHz, 100Kbytes, and 50Kbits/sec per client. It shouldn\'t take any more horsepower than that to take four kilobytes from the disk and send them to the network once a second for each of twenty thousand clients. (That works out to $0.08 per client, by the way. Those $100/client licensing fees some operating systems charge are starting to look a little heavy!) So hardware is no longer the bottleneck.</p>\n<p>In 1999 one of the busiest ftp sites, cdrom.com, actually handled 10000 clients simultaneously through a Gigabit Ethernet pipe. As of 2001, that same speed is now&nbsp;<a href=\"http://www.senteco.com/telecom/ethernet.htm\">being offered by several ISPs</a>, who expect it to become increasingly popular with large business customers.</p>\n<p>And the thin client model of computing appears to be coming back in style -- this time with the server out on the Internet, serving thousands of clients.</p>\n<p>With that in mind, here are a few notes on how to configure operating systems and write code to support thousands of clients. The discussion centers around Unix-like operating systems, as that\'s my personal area of interest, but Windows is also covered a bit.</p>\n<h2 style=\"color: rgb(0, 0, 0); font-family: \'Times New Roman\'; line-height: normal;\">Contents</h2>\n<ul style=\"color: rgb(0, 0, 0); font-family: \'Times New Roman\'; font-size: medium; line-height: normal;\">\n<li><a href=\"http://www.kegel.com/c10k.html#top\">The C10K problem</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#related\">Related Sites</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#books\">Book to Read First</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#frameworks\">I/O frameworks</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#strategies\">I/O Strategies</a><ol>\n<li><a href=\"http://www.kegel.com/c10k.html#nb\">Serve many clients with each thread, and use nonblocking I/O and&nbsp;<b>level-triggered</b>&nbsp;readiness notification</a><ul>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.select\">The traditional select()</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.poll\">The traditional poll()</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb./dev/poll\">/dev/poll</a>&nbsp;(Solaris 2.7+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.kqueue\">kqueue</a>&nbsp;(FreeBSD, NetBSD)</li>\n</ul>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.edge\">Serve many clients with each thread, and use nonblocking I/O and readiness&nbsp;<b>change</b>&nbsp;notification</a><ul>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.epoll\">epoll</a>&nbsp;(Linux 2.6+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.kevent\">Polyakov\'s kevent</a>&nbsp;(Linux 2.6+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.newni\">Drepper\'s New Network Interface</a>&nbsp;(proposal for Linux 2.6+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.sigio\">Realtime Signals</a>&nbsp;(Linux 2.4+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.sigfd\">Signal-per-fd</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#nb.kqueue\">kqueue</a>&nbsp;(FreeBSD, NetBSD)</li>\n</ul>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#aio\">Serve many clients with each thread, and use asynchronous I/O and completion notification</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#threaded\">Serve one client with each server thread</a><ul>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.linuxthreads\">LinuxThreads</a>&nbsp;(Linux 2.0+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.ngpt\">NGPT</a>&nbsp;(Linux 2.4+)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.nptl\">NPTL</a>&nbsp;(Linux 2.6, Red Hat 9)</li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.freebsd\">FreeBSD threading support</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.netbsd\">NetBSD threading support</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.solaris\">Solaris threading support</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#threads.java\">Java threading support in JDK 1.3.x and earlier</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#1:1\">Note: 1:1 threading vs. M:N threading</a></li>\n</ul>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#kio\">Build the server code into the kernel</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#userspace\">Bring the TCP stack into userspace</a></li>\n</ol>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#comments\">Comments</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#limits.filehandles\">Limits on open filehandles</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#limits.threads\">Limits on threads</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#java\">Java issues</a>&nbsp;[Updated 27 May 2001]</li>\n<li><a href=\"http://www.kegel.com/c10k.html#tips\">Other tips</a><ul>\n<li><a href=\"http://www.kegel.com/c10k.html#zerocopy\">Zero-Copy</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#sendfile\">The sendfile() system call can implement zero-copy networking.</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#writev\">Avoid small frames by using writev (or TCP_CORK)</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#nativethreads\">Some programs can benefit from using non-Posix threads.</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#caching\">Caching your own data can sometimes be a win.</a></li>\n</ul>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#limits.other\">Other limits</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#kernel\">Kernel Issues</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#benchmarking\">Measuring Server Performance</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples\">Examples</a><ul>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.nb.select\">Interesting select()-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.nb./dev/poll\">Interesting /dev/poll-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.nb.epoll\">Interesting epoll-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.nb.kqueue\">Interesting kqueue()-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.nb.sigio\">Interesting realtime signal-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.threaded\">Interesting thread-based servers</a></li>\n<li><a href=\"http://www.kegel.com/c10k.html#examples.kio\">Interesting in-kernel servers</a></li>\n</ul>\n</li>\n<li><a href=\"http://www.kegel.com/c10k.html#links\">Other interesting links<br></a></li>\n</ul>\n<p style=\"color: rgb(0, 0, 0); font-family: \'Times New Roman\'; font-size: medium; line-height: normal;\"></p>',1429540487,'admin',0),(7,401,'零费用建站','<p>提供商： OpenShift + TK + DNSPOT</p><p>OpenShift：提供主机空间， 二级域名 不过国内屏蔽，只能访问https，速度够慢， 提供git代码提交， 免费一年<br></p><p>TK：免费一级域名，可以转发到OpenShift申请的二级域名<br></p><p>DNSPOT：dns加速，设置CNAME到二级域名，并更改TK的NS<br></p>',1429518081,'admin',0),(8,2001,'书单','<div>unix环境高级编程</div>\n<div>unix网络编程</div>\n<div>unix进程间通信</div>\n<div>tcp/ip详解卷1</div>\n<div><br></div>\n<div>高性能Mysql</div>\n<div>mysql优化</div>\n<div>Redis设计与实现</div>\n<div><br></div>\n<div>操作系统</div>\n<div>编译链接</div>\n<div>linux设计与实现</div>\n<div>shell入门与精通</div>\n<div><br></div>\n<div>c++primer</div>\n<div>stl源码剖析</div>\n<div>effective c++</div>\n<div>c++对象模型</div>\n<div>Python/php/Shell</div>\n<div><br></div>\n<div>数据结构</div>\n<div>剑指offer</div>\n<div>算法导论</div>\n<div><br></div>\n<div>分布式</div>\n<div>性能测试</div>\n<div>负载均衡</div>\n<div>大数据</div>\n<div>服务器性能</div>\n<div><br></div>\n<div>源码阅读</div>\n<div>Linux内核</div>\n<div>Redis</div>\n<div>libevent</div>\n<div>nginx</div>\n<div>memcached</div>\n<div>chrome</div>\n<div>leveldb</div>\n<div>webbench</div>\n<div>tinyhttpd</div>\n<div>cJson</div>\n<div>lua</div>\n<div>sqlite</div>\n<div>unix v6</div>\n<div>protobuf</div>',1429541383,'admin',0),(9,501,'网站性能','<p>本站刚建立，虽然每秒只能响应4-5个请求，但是对于个人博客来说已经足够，免费搭建起来的也不错哦! 增加并发量每秒可达将300.<img src=\"img/upload/38af86134b65d0f10fe33d30dd76442e.png\" style=\"width: 471.5px; height: 474.175936435868px;\"></p>',1429606530,'admin',0),(10,402,'Blog开发遇到问题','<p>备份：可以利用mysqldump把数据库定时备份，另外打包blog中的图片资源;</p><p>发布：由于Openshift利用git来管理，所以，每次需要从远程把数据库，图片等scp到本地，然后再初始化本地数据，最后复制到本地的远程clone，最后git push到master上;</p><p>mysql访问地址不对，需要echo出mysql host ($OPENSHIFT_MYSQL_DB_HOST) &amp; port;&nbsp;</p><p>dnspod：需要用国际版，国内的访问不行;</p><p><br></p><p><br></p>',1429588065,'admin',0),(11,401,'一种缓存区设计方案','<div>网络或者应用缓程中，经常需要把数据缓存到一个缓存区中，用的时候再从中取出来，以下介绍是类似于libevent中的缓存区实现，&nbsp;</div><div>class ByteBuffer {</div><div>&nbsp; &nbsp; &nbsp;char * m_buff; //缓存区地址</div><div>&nbsp; &nbsp; &nbsp;int &nbsp; &nbsp; &nbsp;m_size; &nbsp;//长度</div><div>&nbsp; &nbsp; &nbsp;int &nbsp; &nbsp; &nbsp;m_head; //可读地址偏移</div><div>&nbsp; &nbsp; &nbsp;int &nbsp; &nbsp; &nbsp;m_tail; &nbsp; &nbsp;//可写地址偏移</div><div>}</div><div>写入len长度到缓存区：判断m_size-m_tail是否大于len,如果大于，则写入，m_tail += len; 否则reserver m_buff大小， 可以调用realloc</div><div>读缓存区：首先判断m_tail - m_head是否小于m_head,如果是， 则平移数据到头部，即m_head=0, m_tail = len；否则读取数据，m_head+=len</div><div><br></div><div>类似于muduo Buffer设计，我想差不多都是参考evbuffer来设计的，只不过muduo为了实际应用需要，在前面附加了一个长度字段用来表现序列化不知道长度的情况。</div>',1429776770,'admin',0),(12,101,'C++模板全特化与偏特化','<p>模板为什么要特化，因为编译器认为，对于特定的类型，如果你能对某一功能更好的实现，那么就该听你的。</p>\n<p>模板分为类模板与函数模板，特化分为全特化与偏特化。全特化就是限定死模板实现的具体类型，偏特化就是如果这个模板有多个类型，那么只限定其中的一部分。</p>\n<p>先看类模板：</p>\n<p>template&lt;typename T1, typename T2&gt;&nbsp;</p>\n<p>class Test</p>\n<p>{</p>\n<p>&nbsp; &nbsp; public:</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; Test(T1 i,T2 j):a(i),b(j){cout&lt;&lt;\"模板类\"&lt;&lt;endl;}</p>\n<p>&nbsp; &nbsp; private:</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; T1 a;</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; T2 b;</p>\n<p>};</p>\n<p>template&lt;&gt;</p>\n<p>class Test&lt;int , char&gt;</p>\n<p>{</p>\n<p>&nbsp; &nbsp; public:</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; Test(int i, char j):a(i),b(j){cout&lt;&lt;\"全特化\"&lt;&lt;endl;}</p>\n<p>&nbsp; &nbsp; private:</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; int a;</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; char b;</p>\n<p>};</p>\n<p>template &lt;typename T2&gt;&nbsp;</p>\n<p>class Test&lt;char, T2&gt;&nbsp;</p>\n<p>{</p>\n<p>&nbsp; &nbsp; public:</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; Test(char i, T2 j):a(i),b(j){cout&lt;&lt;\"偏特化\"&lt;&lt;endl;}</p>\n<p>&nbsp; &nbsp; private:</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; char a;</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; T2 b;</p>\n<p>};&nbsp;</p>\n<p>而对于函数模板，却只有全特化，不能偏特化：<br></p>\n<p></p>\n<p>那么下面3句依次调用类模板、全特化与偏特化：</p>\n<p><span class=\"Apple-tab-span\" style=\"white-space: pre;\">	</span>Test&lt;double , double&gt; t1(0.1,0.2);</p>\n<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Test&lt;int , char&gt; t2(1,\'A\');<br></p>\n<p></p>\n<p></p>\n<p><span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span>Test&lt;char, bool&gt; t3(\'A\',true);</p>\n<p></p>\n<p></p>\n<p></p>\n<p>//模板函数</p>\n<p>template&lt;typename T1, typename T2&gt;</p>\n<p>void fun(T1 a , T2 b)</p>\n<p>{</p>\n<p>cout&lt;&lt;\"模板函数\"&lt;&lt;endl;</p>\n<p>}</p>\n<p>//全特化<br></p>\n<p>template&lt;&gt;</p>\n<p>void fun&lt;int ,char &gt;(int a, char b)</p>\n<p>{</p>\n<p><span class=\"Apple-tab-span\" style=\"white-space:pre\">	</span>cout&lt;&lt;\"全特化\"&lt;&lt;endl;</p>\n<p>}</p>\n<p>//函数不存在偏特化：下面的代码是错误的<br></p>\n<p>/*template&lt;typename T2&gt;</p>\n<p>void fun&lt;char,T2&gt;(char a, T2 b)</p>\n<p>{</p>\n<p>cout&lt;&lt;\"偏特化\"&lt;&lt;endl;</p>\n<p>}*/</p>\n<p>至于为什么函数不能偏特化，似乎不是因为语言实现不了，而是因为偏特化的功能可以通过函数的重载完成。</p>\n<p><a href=\"http://blog.csdn.net/thefutureisour/article/details/7964682/\" target=\"_blank\">http://blog.csdn.net/thefutureisour/article/details/7964682/</a><span style=\"font-family: Arial; line-height: 26px;\"><br></span></p>',1429689324,'admin',1),(13,501,'Redis性能测试','<span style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\">个人感觉redis有太多的好处，节省了大家开发的时间，提供的基本类型大致满足了开发需求，&nbsp;</span><div style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\">虽然其也有一些坑，但我想总是能避免的&nbsp;</div><div style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\"><div>测试环境：Intel(R) Xeon(R) CPU &nbsp; &nbsp;E5504&nbsp; @ 2.00GHz 8核 8G</div><div>单进程一个连接:</div></div><div style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\">官方的测试能跑出每秒近10w的成绩，当然并发量为50个</div><div style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\">但自己的只能跑出每秒近1w的成绩，估计是由于自己是单个进程单并发吧</div><pre style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\">#!/usr/bin/python\n<pre>#encoding: utf-8\nimport sys<br>import struct<br>import time<br>import redis<br>import random\ncount = 1000000;<br>def test_hset_init(r, tmpstr):<br>&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp; total = 0;<br>&nbsp;&nbsp;&nbsp; cur = time.time() * 1000000;<br>&nbsp;&nbsp;&nbsp; for i in range(0, count):<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r.hset(\"blade\", i, tmpstr);<br>&nbsp;&nbsp;&nbsp; last = time.time() * 1000000;<br>&nbsp;&nbsp;&nbsp; #&nbsp;&nbsp;&nbsp; print \"第%u个使用%uus\" % (i, (last-cur))<br>&nbsp;&nbsp;&nbsp; total += (last - cur)\n&nbsp;&nbsp;&nbsp; print \"hset init 总计时间为:%u us, 平均时间为:%u us\" % (total, total / (count*1.0))&nbsp;\n&nbsp;&nbsp;&nbsp; pass\ndef test_hset_op(r, tmpstr):<br>&nbsp;&nbsp;&nbsp; total = 0<br>&nbsp;&nbsp;&nbsp; cur = time.time() * 1000000;<br>&nbsp;&nbsp;&nbsp; for i in range(0, count):<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; val = r.hget(\"blade\", i);<br>&nbsp;&nbsp;&nbsp; last = time.time() * 1000000;<br>&nbsp;&nbsp;&nbsp; #&nbsp;&nbsp;&nbsp; print \"第%u个使用%uus\" % (i, (last-cur))<br>&nbsp;&nbsp;&nbsp; total += (last - cur)\n&nbsp;&nbsp;&nbsp; print \"获取hget总计时间为:%u us, 平均时间为:%u us\" % (total, total /&nbsp; (count*1.0))\n&nbsp;&nbsp;&nbsp; total = 0<br>&nbsp;&nbsp;&nbsp; cur = time.time() * 1000000;<br>&nbsp;&nbsp;&nbsp; for i in range(0, count):<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; val = r.hset(\"blade\", i, tmpstr);<br>&nbsp;&nbsp;&nbsp; last = time.time() * 1000000;<br>&nbsp;&nbsp;&nbsp; #&nbsp;&nbsp;&nbsp; print \"第%u个使用%uus\" % (i, (last-cur))<br>&nbsp;&nbsp;&nbsp; total += (last - cur)\n&nbsp;&nbsp;&nbsp; print \"更新hset总计时间为:%u us, 平均时间为:%u us\" % (total, total / (count*1.0))&nbsp;<br>\n&nbsp;&nbsp;&nbsp; pass\ndef test_zset_init(r):<br>&nbsp;&nbsp;&nbsp; total = 0;<br>&nbsp;&nbsp;&nbsp; cur = time.time() * 1000000;<br>&nbsp;&nbsp;&nbsp; for i in range(0, count):<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r.zadd(\"ranking\",&nbsp; 10000000000 + i, i);<br>&nbsp;&nbsp;&nbsp; last = time.time() * 1000000;<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print \"第%u个使用%uus\" % (i, (last-cur))<br>&nbsp;&nbsp;&nbsp; total += (last - cur)\n&nbsp;&nbsp;&nbsp; print \"zadd 总计时间为:%u us, 平均时间为:%u us\" % (total, total /&nbsp; (count*1.0))\n&nbsp;&nbsp;&nbsp; pass\ndef test_zset_op(r):<br>&nbsp;&nbsp;&nbsp; total = 0;<br>&nbsp;&nbsp;&nbsp; cur = time.time() * 1000000;<br>&nbsp;&nbsp;&nbsp; for i in range(0, count):<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rank = r.zrevrank(\"ranking\", 10000000000 + i);<br>&nbsp;&nbsp;&nbsp; last = time.time() * 1000000;<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print \"第%u个使用%uus\" % (i, (last-cur))<br>&nbsp;&nbsp;&nbsp; total += (last - cur)\n&nbsp;&nbsp;&nbsp; print \"zrevrank 总计时间为:%u us, 平均时间为:%u us\" % (total, total /&nbsp; (count*1.0))\n&nbsp;&nbsp;&nbsp; total = 0;<br>&nbsp;&nbsp;&nbsp; cur = time.time() * 1000000;<br>&nbsp;&nbsp;&nbsp; for i in range(0, count):<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; r.zincrby(\"ranking\", 10000000000 + i, i);\n&nbsp;&nbsp;&nbsp; last = time.time() * 1000000;<br>#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print \"第%u个使用%uus\" % (i, (last-cur))<br>&nbsp;&nbsp;&nbsp; total += (last - cur)\n&nbsp;&nbsp;&nbsp; print \"zincrby 总计时间为:%u us, 平均时间为:%u us\" % (total, total /&nbsp; (count*1.0))\n&nbsp;&nbsp;&nbsp; pass\ndef main():<br>&nbsp;&nbsp;&nbsp; r = redis.StrictRedis(host=\'localhost\', port=6379, db=0)<br>&nbsp;&nbsp;&nbsp; r.flushall();\n&nbsp;&nbsp;&nbsp; tmpstr = \"\";<br>&nbsp;&nbsp;&nbsp; for i in range(0, 300):<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tmpstr += str(random.randint(0,9));\n&nbsp;&nbsp;&nbsp; print \"插入的字符串:\", tmpstr, \"长度为:\", len(tmpstr), \"byte\";\n&nbsp;&nbsp;&nbsp; #init hset data 100000 300B<br>&nbsp;&nbsp;&nbsp; print \"hset key为blade 插入数据为%lu个，每长度为300B\" % count<br>&nbsp;&nbsp;&nbsp; test_hset_init(r, tmpstr);\n&nbsp;&nbsp;&nbsp; #test hget hset 10000次 求每次时间<br>&nbsp;&nbsp;&nbsp; print \"hset key为blade 获取和更新 %lu条数据\" % count<br>&nbsp;&nbsp;&nbsp; test_hset_op(r, tmpstr);&nbsp;&nbsp;&nbsp;&nbsp;<br>&nbsp;&nbsp;&nbsp; #init zset data 100000条<br>&nbsp;&nbsp;&nbsp; test_zset_init(r);<br>&nbsp;&nbsp;&nbsp; #test zadd arank 10000次 求每次时间 并求平均时间<br>&nbsp;&nbsp;&nbsp; test_zset_op(r);\n&nbsp;&nbsp;&nbsp; pass\nif __name__ == \'__main__\':<br>&nbsp;&nbsp;&nbsp; main()</pre></pre>',1429696413,'admin',0),(14,501,'Protobuf性能测试','<div><span style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\">protobuf是google出的一种消息序列化组件，无论从性能还是可用性上都非常良好。</span><div style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\">测试环境：Intel(R) Xeon(R) CPU &nbsp; &nbsp;E5504&nbsp; @ 2.00GHz 8核 8G</div><div style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\">序列化大小为420字节结果为：</div><div style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\">序列化执行100000次总花费时间: 1603055usec;平均每次花费: 1.60305usec<br>\n反序列化执行100000次总花费时间: 1197281usec;平均每次花费: 1.19728usec</div><div style=\"color: rgb(0, 0, 0); font-family: 微软雅黑; line-height: normal; orphans: 2; text-align: -webkit-auto; widows: 2; font-size: medium;\">可见其性能非常好，压缩性和可扩展性都比自己写的结构体序列化要好。</div></div>',1429696454,'admin',0),(15,201,'带有详细注释的 Redis 3.0 代码','<p><span style=\"float: left;\">原文</span>&nbsp;&nbsp;<a class=\"cut cut70\" href=\"http://github.com/huangz1990/redis-3.0-annotated?utm_source=tuicool\">http://github.com/huangz1990/redis-3.0-annotated<br></a>Redis 3.0 源码注释<br>附录：各个源码文件的作用简介</p>\n<table class=\"table table-bordered\">\n<thead valign=\"bottom\"><tr>\n<th style=\"border-top-left-radius: 4px;\">文件</th>\n<th style=\"border-top-right-radius: 4px;\">作用</th>\n</tr>\n</thead>\n<tbody valign=\"top\">\n<tr>\n<td>adlist.c&nbsp;、&nbsp;adlist.h</td>\n<td>双端链表数据结构 的实现。</td>\n</tr>\n<tr>\n<td>ae.c&nbsp;、&nbsp;ae.h&nbsp;、&nbsp;ae_epoll.c&nbsp;、&nbsp;ae_evport.c&nbsp;、\n&nbsp;ae_kqueue.c&nbsp;、&nbsp;ae_select.c</td>\n<td>事件处理器，以及各个具体实现。</td>\n</tr>\n<tr>\n<td>anet.c&nbsp;、&nbsp;anet.h</td>\n<td>Redis 的异步网络框架，内容主要为对 socket 库的包装。</td>\n</tr>\n<tr>\n<td>aof.c</td>\n<td>AOF 功能的实现。</td>\n</tr>\n<tr>\n<td>asciilogo.h</td>\n<td>保存了 Redis 的 ASCII LOGO 。</td>\n</tr>\n<tr>\n<td>bio.c&nbsp;、&nbsp;bio.h</td>\n<td>Redis 的后台 I/O 程序，用于将 I/O 操作放到子线程里面执行， 减少 I/O 操作对主线程的阻塞。</td>\n</tr>\n<tr>\n<td>bitops.c</td>\n<td>二进制位操作命令的实现文件。</td>\n</tr>\n<tr>\n<td>blocked.c</td>\n<td>用于实现 BLPOP 命令和 WAIT 命令的阻塞效果。</td>\n</tr>\n<tr>\n<td>cluster.c&nbsp;、&nbsp;cluster.h</td>\n<td>Redis 的集群实现。</td>\n</tr>\n<tr>\n<td>config.c&nbsp;、&nbsp;config.h</td>\n<td>Redis 的配置管理实现，负责读取并分析配置文件， 然后根据这些配置修改 Redis 服务器的各个选项。</td>\n</tr>\n<tr>\n<td>crc16.c&nbsp;、&nbsp;crc64.c&nbsp;、&nbsp;crc64.h</td>\n<td>计算 CRC 校验和。</td>\n</tr>\n<tr>\n<td>db.c</td>\n<td>数据库实现。</td>\n</tr>\n<tr>\n<td>debug.c</td>\n<td>调试实现。</td>\n</tr>\n<tr>\n<td>dict.c&nbsp;、&nbsp;dict.h</td>\n<td>字典数据结构的实现。</td>\n</tr>\n<tr>\n<td>endianconv.c&nbsp;、&nbsp;endianconv.h</td>\n<td>二进制的大端、小端转换函数。</td>\n</tr>\n<tr>\n<td>fmacros.h</td>\n<td>一些移植性方面的宏。</td>\n</tr>\n<tr>\n<td>help.h</td>\n<td>utils/generate-command-help.rb&nbsp;程序自动生成的命令帮助信息。</td>\n</tr>\n<tr>\n<td>hyperloglog.c</td>\n<td>HyperLogLog 数据结构的实现。</td>\n</tr>\n<tr>\n<td>intset.c&nbsp;、&nbsp;intset.h</td>\n<td>整数集合数据结构的实现，用于优化 SET 类型。</td>\n</tr>\n<tr>\n<td>lzf_c.c&nbsp;、&nbsp;lzf_d.c&nbsp;、&nbsp;lzf.h&nbsp;、&nbsp;lzfP.h</td>\n<td>Redis 对字符串和 RDB 文件进行压缩时使用的 LZF 压缩算法的实现。</td>\n</tr>\n<tr>\n<td>Makefile&nbsp;、&nbsp;Makefile.dep</td>\n<td>构建文件。</td>\n</tr>\n<tr>\n<td>memtest.c</td>\n<td>内存测试。</td>\n</tr>\n<tr>\n<td>mkreleasehdr.sh</td>\n<td>用于生成释出信息的脚本。</td>\n</tr>\n<tr>\n<td>multi.c</td>\n<td>Redis 的事务实现。</td>\n</tr>\n<tr>\n<td>networking.c</td>\n<td>Redis 的客户端网络操作库， 用于实现命令请求接收、发送命令回复等工作， 文件中的函数大多为 write 、 read 、 close 等函数的包装， 以及各种协议的分析和构建函数。</td>\n</tr>\n<tr>\n<td>notify.c</td>\n<td>Redis 的数据库通知实现。</td>\n</tr>\n<tr>\n<td>object.c</td>\n<td>Redis 的对象系统实现。</td>\n</tr>\n<tr>\n<td>pqsort.c&nbsp;、&nbsp;pqsort.h</td>\n<td>快速排序（QuickSort）算法的实现。</td>\n</tr>\n<tr>\n<td>pubsub.c</td>\n<td>发布与订阅功能的实现。</td>\n</tr>\n<tr>\n<td>rand.c&nbsp;、&nbsp;rand.h</td>\n<td>伪随机数生成器。</td>\n</tr>\n<tr>\n<td>rdb.c&nbsp;、&nbsp;rdb.h</td>\n<td>RDB 持久化功能的实现。</td>\n</tr>\n<tr>\n<td>redisassert.h</td>\n<td>Redis 自建的断言系统。</td>\n</tr>\n<tr>\n<td>redis-benchmark.c</td>\n<td>Redis 的性能测试程序。</td>\n</tr>\n<tr>\n<td>redis.c</td>\n<td>负责服务器的启动、维护和关闭等事项。</td>\n</tr>\n<tr>\n<td>redis-check-aof.c&nbsp;、&nbsp;redis-check-dump.c</td>\n<td>RDB 文件和 AOF 文件的合法性检查程序。</td>\n</tr>\n<tr>\n<td>redis-cli.c</td>\n<td>Redis 客户端的实现。</td>\n</tr>\n<tr>\n<td>redis.h</td>\n<td>Redis 的主要头文件，记录了 Redis 中的大部分数据结构， 包括服务器状态和客户端状态。</td>\n</tr>\n<tr>\n<td>redis-trib.rb</td>\n<td>Redis 集群的管理程序。</td>\n</tr>\n<tr>\n<td>release.c&nbsp;、&nbsp;release.h</td>\n<td>记录和生成 Redis 的释出版本信息。</td>\n</tr>\n<tr>\n<td>replication.c</td>\n<td>复制功能的实现。</td>\n</tr>\n<tr>\n<td>rio.c&nbsp;、&nbsp;rio.h</td>\n<td>Redis 对文件 I/O 函数的包装， 在普通 I/O 函数的基础上增加了显式缓存、以及计算校验和等功能。</td>\n</tr>\n<tr>\n<td>scripting.c</td>\n<td>脚本功能的实现。</td>\n</tr>\n<tr>\n<td>sds.c&nbsp;、&nbsp;sds.h</td>\n<td>SDS 数据结构的实现，SDS 为 Redis 的默认字符串表示。</td>\n</tr>\n<tr>\n<td>sentinel.c</td>\n<td>Redis Sentinel 的实现。</td>\n</tr>\n<tr>\n<td>setproctitle.c</td>\n<td>进程环境设置函数。</td>\n</tr>\n<tr>\n<td>sha1.c&nbsp;、&nbsp;sha1.h</td>\n<td>SHA1 校验和计算函数。</td>\n</tr>\n<tr>\n<td>slowlog.c&nbsp;、&nbsp;slowlog.h</td>\n<td>满查询功能的实现。</td>\n</tr>\n<tr>\n<td>solarisfixes.h</td>\n<td>针对 Solaris 系统的补丁。</td>\n</tr>\n<tr>\n<td>sort.c</td>\n<td>SORT 命令的实现。</td>\n</tr>\n<tr>\n<td>syncio.c</td>\n<td>同步 I/O 操作。</td>\n</tr>\n<tr>\n<td>testhelp.h</td>\n<td>测试辅助宏。</td>\n</tr>\n<tr>\n<td>t_hash.c&nbsp;、&nbsp;t_list.c&nbsp;、t_set.c&nbsp;、&nbsp;t_string.c&nbsp;、t_zset.c</td>\n<td>定义了 Redis 的各种数据类型，以及这些数据类型的命令。</td>\n</tr>\n<tr>\n<td>util.c&nbsp;、&nbsp;util.h</td>\n<td>各种辅助函数。</td>\n</tr>\n<tr>\n<td>valgrind.sup</td>\n<td>LZF 压缩算法的相关文件。</td>\n</tr>\n<tr>\n<td>version.h</td>\n<td>记录了 Redis 的版本号。</td>\n</tr>\n<tr>\n<td>ziplist.c&nbsp;、&nbsp;ziplist.h</td>\n<td>ZIPLIST 数据结构的实现，用于优化 LIST 类型。</td>\n</tr>\n<tr>\n<td>zipmap.c&nbsp;、&nbsp;zipmap.h</td>\n<td>ZIPMAP 数据结构的实现，在 Redis 2.6 以前用与优化 HASH 类型， Redis 2.6 开始已经废弃。</td>\n</tr>\n<tr>\n<td style=\"border-bottom-left-radius: 4px;\">zmalloc.c&nbsp;、&nbsp;zmalloc.h</td>\n<td style=\"border-bottom-right-radius: 4px;\">内存管理程序。</td>\n</tr>\n</tbody>\n</table>\n<p></p>\n<p></p>\n<p style=\"margin-bottom: 0.75em;\">本项目是注释版的 Redis 3.0 源码， 原始代码来自：&nbsp;<a href=\"https://github.com/antirez/redis\" rel=\"nofollow,noindex\" style=\"transition: 0.25s; -webkit-transition: 0.25s; border-bottom-width: 1px; border-bottom-style: dashed; border-bottom-color: rgb(148, 148, 148);\">https://github.com/antirez/redis</a>&nbsp;。</p>\n<p style=\"margin-bottom: 0.75em;\">这份注释是我在创作新版《Redis 设计与实现》期间， 为了了解 Redis 的内部实现而制作的， 所有在书中有介绍的内容， 在源码中都进行了相应的注释。</p>\n<p style=\"margin-bottom: 0.75em;\">在注释的过程中， 除了少量空格和空行方面的调整外， 没有对原始代码进行任何其他改动， 最大程度地保证了代码的“原汁原味”。</p>\n<p style=\"margin-bottom: 0.75em;\">希望这份注释源码能给大家学习和了解 Redis 带来一点帮助。</p>\n<p style=\"margin-bottom: 0.75em;\">另外，&nbsp;<a href=\"http://redisbook.com/\" rel=\"nofollow,noindex\" style=\"transition: 0.25s; -webkit-transition: 0.25s; border-bottom-width: 1px; border-bottom-style: dashed; border-bottom-color: rgb(148, 148, 148);\">新版《Redis 设计与实现》</a>&nbsp;正在各大网店发售中，&nbsp;<a href=\"http://www.chinahadoop.cn/course/53\" rel=\"nofollow,noindex\" style=\"transition: 0.25s; -webkit-transition: 0.25s; border-bottom-width: 1px; border-bottom-style: dashed; border-bottom-color: rgb(148, 148, 148);\">《Redis 从入门到精通》课程</a>&nbsp;也正在接受报名， 如果这两个项目能获得大家的支持的话， 我将不胜感激。</p>\n<p style=\"margin-bottom: 0.75em;\">Have fun!</p>\n<div><p style=\"margin-bottom: 0.75em;\">黄健宏（huangz）</p>\n<p style=\"margin-bottom: 0.75em;\">2014 年 6 月 28 日</p>\n</div>\n<p><br></p>',1429757698,'admin',1),(16,2001,'Redis源码阅读规划','<span style=\"orphans: 2; text-align: -webkit-auto; widows: 2;\">Redis作为一个很好的内存数据库， 为我们开发提供了很大的便利，其代码虽然没有看完，但从其整体上而言，质量较高，</span><span style=\"line-height: 1.42857143;\">本次打算写一个阅读源码的心得，结合《Redis设计与实现》来看，中间可能做一些实现。 预计三个月，希望自己对NoSql</span><span style=\"line-height: 1.42857143;\">有较深的理解，不会停留在表面。</span>',1429757727,'admin',0),(17,501,'吞吐量','<p>网络吞吐量：吞吐量是指在没有帧丢失的情况下，设备能够接收并转发的最大数据速率\n</p><p>Muduo中利用PingPong来测试网络程序达到的吞吐量是否满， 关于系统吞吐量可以用iperf来测量，我觉得应该进程的吞吐量达到1M-10M已经差不多，因为毕竟系统是为所有进程服务的，所以自己写的网络daemon进程吞吐量在1M-10M就可以。\n可以利用pingpong连续发定长大小L的消息，测试在一定时间T内最后收发的消息数S，那网络进程的吞吐量为S/T*L b/s.</p>',1429778802,'admin',0),(18,502,'流量检测','<p><a href=\"http://www.vpser.net/manage/iftop.html\" target=\"_blank\">http://www.vpser.net/manage/iftop.html</a></p><p>1、iftop界面相关说明<br></p><p>RX：接收流量<br></p><p>TOTAL：总流量<br>Cumm：运行iftop到目前时间的总流量<br>peak：流量峰值<br>rates：分别表示过去 2s 10s 40s 的平均流量<br>2、iftop相关参数<br>常用的参数<br>进入iftop画面后的一些操作命令(注意大小写)</p><p></p><p></p><p style=\"margin-bottom: 1.8em;\">界面上面显示的是类似刻度尺的刻度范围，为显示流量图形的长条作标尺用的。</p><p style=\"margin-bottom: 1.8em;\">中间的&lt;= =&gt;这两个左右箭头，表示的是流量的方向。</p><p style=\"margin-bottom: 1.8em;\">TX：发送流量<br></p><p style=\"margin-bottom: 1.8em;\">-i设定监测的网卡，如：# iftop -i eth1</p><p style=\"margin-bottom: 1.8em;\">-B 以bytes为单位显示流量(默认是bits)，如：# iftop -B</p><p style=\"margin-bottom: 1.8em;\">-n使host信息默认直接都显示IP，如：# iftop -n</p><p style=\"margin-bottom: 1.8em;\">-N使端口信息默认直接都显示端口号，如: # iftop -N</p><p style=\"margin-bottom: 1.8em;\">-F显示特定网段的进出流量，如# iftop -F 10.10.1.0/24或# iftop -F 10.10.1.0/255.255.255.0</p><p style=\"margin-bottom: 1.8em;\">-h（display this message），帮助，显示参数信息</p><p style=\"margin-bottom: 1.8em;\">-p使用这个参数后，中间的列表显示的本地主机信息，出现了本机以外的IP信息;</p><p style=\"margin-bottom: 1.8em;\">-b使流量图形条默认就显示;</p><p style=\"margin-bottom: 1.8em;\">-f这个暂时还不太会用，过滤计算包用的;</p><p style=\"margin-bottom: 1.8em;\">-P使host信息及端口信息默认就都显示;</p><p style=\"margin-bottom: 1.8em;\">-m设置界面最上边的刻度的最大值，刻度分五个大段显示，例：# iftop -m 100M</p><p style=\"margin-bottom: 1.8em;\">按h切换是否显示帮助;</p><p style=\"margin-bottom: 1.8em;\">按n切换显示本机的IP或主机名;</p><p style=\"margin-bottom: 1.8em;\">按s切换是否显示本机的host信息;</p><p style=\"margin-bottom: 1.8em;\">按d切换是否显示远端目标主机的host信息;</p><p style=\"margin-bottom: 1.8em;\">按t切换显示格式为2行/1行/只显示发送流量/只显示接收流量;</p><p style=\"margin-bottom: 1.8em;\">按N切换显示端口号或端口服务名称;</p><p style=\"margin-bottom: 1.8em;\">按S切换是否显示本机的端口信息;</p><p style=\"margin-bottom: 1.8em;\">按D切换是否显示远端目标主机的端口信息;</p><p style=\"margin-bottom: 1.8em;\">按p切换是否显示端口信息;</p><p style=\"margin-bottom: 1.8em;\">按P切换暂停/继续显示;</p><p style=\"margin-bottom: 1.8em;\">按b切换是否显示平均流量图形条;</p><p style=\"margin-bottom: 1.8em;\">按B切换计算2秒或10秒或40秒内的平均流量;</p><p style=\"margin-bottom: 1.8em;\">按T切换是否显示每个连接的总流量;</p><p style=\"margin-bottom: 1.8em;\">按l打开屏幕过滤功能，输入要过滤的字符，比如ip,按回车后，屏幕就只显示这个IP相关的流量信息;</p><p style=\"margin-bottom: 1.8em;\">按L切换显示画面上边的刻度;刻度不同，流量图形条会有变化;</p><p style=\"margin-bottom: 1.8em;\">按j或按k可以向上或向下滚动屏幕显示的连接记录;</p><p style=\"margin-bottom: 1.8em;\">按1或2或3可以根据右侧显示的三列流量数据进行排序;</p><p style=\"margin-bottom: 1.8em;\">按&lt;根据左边的本机名或IP排序;</p><p style=\"margin-bottom: 1.8em;\">按&gt;根据远端目标主机的主机名或IP排序;</p><p style=\"margin-bottom: 1.8em;\">按o切换是否固定只显示当前的连接;</p><p style=\"margin-bottom: 1.8em;\">按f可以编辑过滤代码，这是翻译过来的说法，我还没用过这个！</p><p style=\"margin-bottom: 1.8em;\">按!可以使用shell命令，这个没用过！没搞明白啥命令在这好用呢！</p><p style=\"margin-bottom: 1.8em;\">按q退出监控。</p>',1429782755,'admin',0),(19,101,'jqGrid 使用','<div style=\"orphans: 2; text-align: -webkit-auto; widows: 2;\"><p>jquery jqGrid的确很强大，由于时间问题所以没有按分页拉取数据，<br></p><p>实现功能很简单，按restful api来操作数据。<br></p><p>工具栏使用了inlineNav, 由于其中只提供了add/edit，所以只能自己<br></p><p>实现del button, 所用方法为newButtonAdd， 实现起来也不难， 总共花费<br></p><p>两天时间，实现了数据的增删改查。<br>用的时候一定要用高版本,下面是实现代码 index.js&nbsp;</p><div><pre style=\"text-align: -webkit-auto;\"><span style=\"color: rgb(0, 0, 0); font-family: Courier, \'Courier New\', monospace; line-height: normal;\">var lastSelection = 0;\n\nDate.prototype.format =function(format)\n{\n    var o = {\n        \"M+\" : this.getMonth()+1, //month\n        \"d+\" : this.getDate(), //day\n        \"h+\" : this.getHours(), //hour\n        \"m+\" : this.getMinutes(), //minute\n        \"s+\" : this.getSeconds(), //second\n        \"q+\" : Math.floor((this.getMonth()+3)/3), //quarter\n        \"S\" : this.getMilliseconds() //millisecond\n    }\n    if(/(y+)/.test(format)) format=format.replace(RegExp.$1,\n        (this.getFullYear()+\"\").substr(4- RegExp.$1.length));\n    for(var k in o)if(new RegExp(\"(\"+ k +\")\").test(format))\n        format = format.replace(RegExp.$1,\n                RegExp.$1.length==1? o[k] :\n                (\"00\"+ o[k]).substr((\"\"+ o[k]).length));\n    return format;\n}\n\nfunction getStateName(state)\n{\n    var stateName = [\"流畅\", \"拥挤\", \"维护\"];\n    if (state == 0 || state &gt; stateName.length) {\n        return \"None\";\n    }\n    return stateName[state - 1];\n}\n\nfunction getRecommendName(state)\n{\n    if (state == 0) {\n        return \"否\";\n    } else {\n        return \"是\";\n    }\n}\n\nfunction formatDate(time) {\n    return new Date(time*1000).format(\"yyyy-MM-dd hh:mm:ss\");\n}\n\nfunction fetchZoneList()\n{\n    var gridArrayData = [];\n    $(\'#list\')[0].grid.beginReq();\n    $.ajax({\n        url : \"/zone/all/json\",\n        success : function(res) {\n            for (var i = 0; i &lt; res.zone.length; ++i) {\n                var item = res.zone[i];\n                gridArrayData.push({\n                    serv_id : item.serv_id,\n                    serv_name : item.serv_name,\n                    remote_ip : item.remote_ip,\n                    port : item.port,\n                    state : getStateName(item.state),\n                    recommend_flag : getRecommendName(item.recommend_flag),\n                    publish_time : formatDate(item.publish_time)\n                });\n            }\n\n            $(\'#list\').jqGrid(\'setGridParam\', {data : gridArrayData, rowNum : 10});\n            $(\'#list\')[0].grid.endReq();\n            $(\'#list\').trigger(\'reloadGrid\');\n        }\n    });\n\n    $(\'#delButton\').addClass(\'ui-state-disabled\');\n    lastSelection = 0;\n}\n\n/* @brief 初始化数据\n */\nfunction initData()\n{\n    $(\'#list\').jqGrid({\n        colNames : [\'编号\', \'名称\', \'ip地址\', \'端口号\', \'状态\', \'是否推荐\', \'发布时间\'],\n        colModel: [\n            {name : \'serv_id\', index : \'serv_id\', width : 70, align : \'center\', editable : true, sorttype: \'integer\'},\n            {name : \'serv_name\', index : \'serv_name\', width : 150, align : \'center\', editable : true},\n            {name : \'remote_ip\', index : \'remote_ip\', width : 120, align : \'center\', editable : true},\n            {name : \'port\', index : \'port\', width : 80, align : \'center\', editable : true},\n            {name : \'state\', index : \'state\', width : 80, align : \'center\',\n                editable : true,\n                edittype : \'select\',\n                editoptions : {\n                    value : \"1 : 流畅; 2 :拥挤;3:维护\"\n                }\n            },\n            {name : \'recommend_flag\', index : \'recommend_flag\', width : 80, align : \'center\', editable : true,\n                editable : true,\n                edittype : \'select\',\n                editoptions : {\n                    value : \"0:否;1:是\"\n                }\n            },\n            {name : \'publish_time\', index : \'publish_time\', width : 150, align : \'center\', editable : false}\n        ],\n        showrecords : true,\n        datatype : \'local\',\n        rowNum : 10,\n        height : 270,\n        hoverrows : true,\n        altRows : true,\n        shrinkToFit: true,\n        pager : \'#list_pager\',\n        caption : \"服务器列表\",\n        onSelectRow : selectRow\n    });\n    fetchZoneList();\n\n    function selectRow(id)\n    {\n        lastSelection = id;\n        $(\'#delButton\').removeClass(\'ui-state-disabled\');\n    }\n\n    $(\'#list\').inlineNav(\'#list_pager\', {\n        edit:true,\n        add : true,\n        del: true,\n        save: true,\n        cancel : true,\n        position: \"left\",\n        edittext : \'编辑\',\n        addtext : \'新增\',\n        savetext : \'保存\',\n        canceltext : \'取消\',\n        deltext : \"删除\",\n        editParams : {\n            mtype : \"POST\",\n            keys : true,\n            url : \"/zone\",\n            aftersavefunc : function(rowid, res) {\n                fetchZoneList();\n            }\n        },\n        addParams: {\n            addRowParams : {\n                mtype : \"PUT\",\n                keys : true,\n                url : \"/zone\",\n                aftersavefunc : function(rowid, res) {\n                    fetchZoneList();\n                }\n            }\n        }\n    });\n    $(\'#list\').navButtonAdd(\'#list_pager\',{\n        caption : \'删除\',\n        buttonicon : \"ui-icon-trash\",\n        onClickButton : function () {\n            if (lastSelection !== 0) {\n                var serv_id = $(\'#list\').jqGrid(\'getCell\', lastSelection, \'serv_id\');\n                $.ajax({\n                    url : \"/zone/\" + serv_id,\n                    type : \"DELETE\",\n                    success : function(result) {\n                        if (result == 1) {\n                            fetchZoneList();\n                        } else {\n                            alert(\"删除失败!\");\n                        }\n                    }\n                });\n            } else {\n               alert(\"没有选中行\");\n            }\n        },\n        position : \"last\",\n        id : \"delButton\"\n    });\n\n    $(\'#delButton\').addClass(\'ui-state-disabled\');\n}\n\n$(document).ready(function(){\n    initData();\n});</span></pre></div><p></p><p></p><p></p><p></p><p style=\"\"><span style=\"color: rgb(0, 0, 0); font-family: Courier, \'Courier New\', monospace; font-size: medium; line-height: normal; text-align: -webkit-auto; background-color: rgb(255, 255, 255);\">index.html 加入下面两句:</span></p><pre style=\"\">&lt;table id=\"list\"&gt;&lt;/table&gt;\n&lt;div id=\"list_pager\"&gt;&lt;/div&gt;<span style=\"font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; font-size: 14px; line-height: 20px; white-space: normal;\">\n</span></pre><div>http://www.tuicool.com/articles/36Rr6zf &nbsp;是json格式 服务器分页<br></div></div>',1430303360,'admin',0),(20,106,'NodeJS Express搭建Http服务器','<div><span style=\"orphans: 2; text-align: -webkit-auto; widows: 2;\">由于业务需要，需要用nodejs架构一个http， 为了方便不自己写http相关的东西， 所以用到了express，&nbsp;</span><div>天生支持restful请求，所以用起来特别方便， 但是由于开源，所以使用的东西需要了解清楚。</div><div>环境： webstorm， 调试方便&nbsp;</div><div>协议应用：json, 由于业务需要，用到protobuf，这里使用node-protobuf， windows编译看官网, Linux Simple?</div><div>业务处理流程： async库，看doc 解释很清楚</div><div>config读取 : config.json</div><div>express app获取： router的req.app</div><div>数据库：mysql pool 不需要generic-pool</div><div>由于需要启动多个来服务，所以加入commander 以读取命令行参数，否则还得自己解析process.argv</div><br></div>',1430298639,'admin',0),(21,101,'Android SDK Manager国内无法更新的解决方案','设置代理&nbsp;<span style=\"font-family: tahoma, 宋体; line-height: 22.3999996185303px; text-align: justify; background-color: rgb(250, 250, 252);\">mirrors.neusoft.edu.cn , 端口80，再去除force https</span>',1430711357,'admin',0),(22,601,'Unity网络接收模块Bug','<div><div>说下情况，楼主为后端码农，做好的游戏烧到手机里，竟然包大小超过一定限制就登陆不上去了，</div><div>前端人不在， 只好我们后端的一起来调，我们使用的是unity。</div><div>这个问题可能有几个因素：</div><div>1.后端没有把数据发给前端</div><div>2.前端没有处理好数据</div><div><br></div><div>由于我们在日志已清楚的记录了发给前端的数据大小和协议号， 后来在前端加日志，发现前端已经成功收到。</div><div><br></div><div>由于PC上很难复现，在手机竟然必现，只好每次编译烧到手机，来回10+次，在Eclipse看日志， 发现包解析到</div><div>一定的时候不再解析， 由于手机上只能看日志，不能调试，所以想办法能在VS里面调试多好^-^</div><div><br></div><div>于是想办法，我想肯定粘包没有处理好，复现粘包问题，只好设置服务端的发送缓存区，设置成50， 看你粘不?</div><div><br></div><div>于是PC登录，必现， 哈哈</div><div>现在可以用VS attach到Unity上Debug了， 结果发现前端没有理解Positon的含义， 当buffer里有数据的时候，position</div><div>没有移到末尾。正常情况下，应该移到末尾，拷贝完后再将position移到原来的位置，再进行读取。</div><div><br></div><span style=\"orphans: 2; text-align: -webkit-auto; widows: 2;\">Positon: 偏移</span><div>Length: &nbsp;占用长度</div><div>Capacity: 容量</div><div><br></div><div>Write Read 时候从position开始, 再加上offset来操作</div><div>Length记录缓存区的长度及末尾， 当position==Length时，没有数据，所以可以清0</div><div>Capacity: 动态扩展，不用管</div><div><br></div><br></div>',1431053388,'admin',0);
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

-- Dump completed on 2015-05-09  7:48:13
