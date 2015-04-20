-- MySQL dump 10.13  Distrib 5.5.40, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: blog
-- ------------------------------------------------------
-- Server version	5.5.40-0ubuntu0.14.04.1

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
  `content` varchar(10240) DEFAULT NULL COMMENT '内容',
  `pub_time` int(10) unsigned DEFAULT NULL COMMENT '发表时间',
  `author` varchar(64) DEFAULT NULL COMMENT '作者',
  `from_type` tinyint(4) DEFAULT '0' COMMENT '来源',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_info`
--

LOCK TABLES `t_info` WRITE;
/*!40000 ALTER TABLE `t_info` DISABLE KEYS */;
INSERT INTO `t_info` VALUES (1,101,'C','fdafdasfdas',1429338529,'admin',0),(2,101,'23243','请输入文字234234',1429338562,'admin',0),(3,101,'2342432','fdafasfa',1429338594,'admin',0),(5,101,'wq','请输入文字fdafa',1429339516,'admin',0),(6,101,'习近平今年首次出访 谱写周边外交新篇章','<p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　新华网北京4月17日电（记者谭晶晶、崔文毅）国家主席习近平将于20日至21日对巴基斯坦进行国事访问，21日至24日赴印度尼西亚出席亚非领导人会议和万隆会议60周年纪念活动。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　2015年习近平主席的首次出访选择周边国家，显示周边外交在中国外交战略中的首要地位。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　<strong style=\"border: 0px; margin: 0px; padding: 0px;\">深耕周边　促双边合作新成果</strong></p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　访问巴基斯坦将是习近平主席作为中国国家元首首次访巴，也将是中国国家主席时隔9年再次踏上巴基斯坦的土地。外交部长王毅表示，这必将成为一次载入史册的重要访问。相信这次访问一定会进一步巩固中巴全天候友谊，深化中巴全方位合作，将“中巴命运共同体”打造成为中国同周边国家构建命运共同体的样板和典范。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　“中巴关系在中国周边外交中处于非常突出的地位。中巴经济走廊已经有了良好开端，这个项目无论是对中国东中西部平衡发展还是对巴基斯坦的基础设施、工业园区建设，都有非凡意义。如何推动走廊建设顺利开展、早出成果，预计将是两国领导人讨论的重要议题之一。”中国前驻巴基斯坦、印尼大使周刚说。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　北起新疆喀什、南至巴基斯坦瓜达尔港的中巴经济走廊，是一条包括公路、铁路、油气和光缆通道在内的贸易走廊，也是“一带一路”的重要组成部分。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　巴基斯坦驻华大使马苏德·哈立德表示，习主席访巴期间，双方将签署能源、基础设施、教育和文化交流等一系列合作协议。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　<strong style=\"border: 0px; margin: 0px; padding: 0px;\">万隆会议60年　亚非携手绘新蓝图</strong></p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　60年前，亚非上空风雷激荡。万隆会议冲破各种阻挠成功召开，中、印、缅提出的和平共处五项原则得以推广。亚非会议是新中国外交史上的重要里程碑，新中国在国际舞台赢得了极高声誉，也获得更为广阔的外交空间。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　60年后，习近平主席将同亚非国家领导人在万隆重温当年亚非领袖的“历史性步行”，共同缅怀历史，展望未来，携手绘制共同发展的蓝图。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　据印尼方面的安排，4月19日至23日将在雅加达举行亚非国家领导人系列会议。24日，各国领袖将在万隆市出席亚非会议60周年纪念活动。据报道，今年举行的亚非会议活动将签署多项合作文件，包括加强新亚非战略伙伴关系、重申万隆精神等。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　“当年的万隆会议是新中国外交一次非常出彩的表现，在某种意义上打破了西方对中国的歪曲和封锁。万隆会议后，亚洲许多国家和中国建立了友好关系。”中国公共外交协会副会长马振岗说。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　分析人士认为，习近平主席届时很可能将阐述新时期的万隆精神，提出新形势下加强亚非合作的新倡议。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　“如果说60年前和平相处、求同存异是万隆精神的时代主题，那么60年后的今天，共同发展、合作共赢则最能顺应时代潮流和民心所向。亚非国家应该与时俱进，在继承和发扬万隆精神的同时，赋予万隆精神新的时代内涵。”中国驻印尼大使谢锋说。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　<strong style=\"border: 0px; margin: 0px; padding: 0px;\">周边是首要　打造命运共同体</strong></p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　2015年首次出访选择周边国家，足见习近平主席对周边外交工作的重视。此次出访的巴基斯坦和印尼都是中国提出的“一带一路”战略构想的重要合作伙伴，也是亚投行的意向创始成员国。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　“通过‘一带一路’、亚投行和丝路基金等平台，中国致力于和亚洲乃至世界各国建立命运共同体。”北京大学国际关系学院教授翟崑说。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　今年以来，中国和周边国家密切互动，增进共识，磋商合作，寻求以对话合作管控分歧。4月上旬，越共中央总书记阮富仲到访北京，这是习近平和阮富仲作为两党总书记的首次会面。中越领导人一致同意，要珍惜和维护中越传统友谊，恪守两党两国领导人达成的重要共识，共同管控好海上分歧，维护中越关系大局和南海和平稳定。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　“周边互动频繁，是贯彻去年中央外事工作会议统筹发展与安全两件大事的精神，以沟通促缓和气氛，寻求解决问题的办法。”翟崑说。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　党的十八大以来，经略周边进一步成为中国塑造全球外交战略格局的重要内容。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　外交学院亚洲研究所所长魏玲认为，从共同、综合、合作、可持续的亚洲安全观到“一带一路”、亚投行、丝路基金等经济合作倡议，习主席提出的“中国理念”、“中国方案”都显示出我们致力于同周边及世界各国打造命运共同体、利益共同体，也显示出周边外交在中国外交战略中的首要地位。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　在中国国际问题研究院副院长阮宗泽看来，“一带一路”和亚投行代表了中国更高水平的开放，将使中国获得新一轮的发展；通过为亚洲基础设施建设提供融资，提升互联互通水平，亚投行将帮助亚洲地区实现又一次经济腾飞。</p><p style=\"border: 0px; margin-bottom: 0px; padding: 26px 0px 0px; color: rgb(0, 0, 0); font-family: 宋体, simsun, sans-serif, Arial; line-height: 26px;\">　　专家表示，习近平主席此访也是新一届领导集体在“亲、诚、惠、容”理念指导下推进周边外交的重要步骤。</p>',1429343501,'admin',0);
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

-- Dump completed on 2015-04-20 12:37:10
