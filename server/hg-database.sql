-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: hg
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.04.2

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
-- Table structure for table `children`
--

DROP TABLE IF EXISTS `children`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `children` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `image_large` varchar(255) DEFAULT NULL,
  `image_small` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `children`
--

LOCK TABLES `children` WRITE;
/*!40000 ALTER TABLE `children` DISABLE KEYS */;
INSERT INTO `children` VALUES (2,'Aleksander \"Bruce\"','Aleksander \"Bruce,\" born November 1999, is a sweet boy who loves sports and video games. He has a soft heart and enjoys church greatly. He is a very helpful and engaging young man. He is social and loves to talk. He has a great imagination. He loves football and hopes to play for the NFL when he grows up and if that doesn\'t work out he will be a police officer. Bruce is a charming child who longs for a forever family to call his own.','http://www.heartgalleryalabama.com/images/children/primary/1355853731_bruce_011.jpg','http://www.heartgalleryalabama.com/images/children/thumbs/primary/small_1355853731_bruce_011.jpg'),(3,'Acacia','Acacia, born January 1998 is an outgoing and personable young lady. She enjoys attention she receives from others and takes pride in her appearance. She enjoys making new friends and adjusts to new situations easily. Acacia is very artistic and enjoys working on arts and crafts projects. She has very good verbal skills and has the ability to do well in school when not distracted by others.','http://www.heartgalleryalabama.com/images/children/primary/1367953229_acacia.jpg','http://www.heartgalleryalabama.com/images/children/thumbs/primary/small_1367953229_acacia.jpg'),(4,'Alex L.','Alexander, born June 1999 is a cute boy with a contagious smile. He earns good grades in school by completing his assignments and studying hard for tests. He is in a self- contained classroom, but was taking math and english in the mainstream classes. Eventually, the goal is for Alex to no longer need the self-contained class.','http://www.heartgalleryalabama.com/images/children/primary/1345492076_alex.jpg','http://www.heartgalleryalabama.com/images/children/thumbs/primary/small_1345492076_alex.jpg');
/*!40000 ALTER TABLE `children` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `media` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `child_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES (1,2,'aleksander_img_1.png',1),(2,2,'aleksander_img_2.png',1),(3,2,'aleksander_mov_1.mp4',2),(4,2,'aleksander_mov_2.mp4',2);
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-08-01 12:15:57
