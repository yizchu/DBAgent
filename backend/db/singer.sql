-- MySQL dump 10.13  Distrib 8.4.4, for Linux (x86_64)
--
-- Host: localhost    Database: db
-- ------------------------------------------------------
-- Server version	8.4.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */
;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */
;
/*!50503 SET NAMES utf8mb4 */
;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */
;
/*!40103 SET TIME_ZONE='+00:00' */
;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */
;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */
;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */
;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */
;

--
-- Table structure for table `singer`
--

DROP TABLE IF EXISTS `singer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `singer` (
    `Singer_ID` tinyint NOT NULL,
    `Name` varchar(19) DEFAULT NULL,
    `Birth_Year` decimal(5, 1) DEFAULT NULL,
    `Net_Worth_Millions` decimal(3, 1) DEFAULT NULL,
    `Citizenship` varchar(13) DEFAULT NULL,
    PRIMARY KEY (`Singer_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `singer`
--

LOCK TABLES `singer` WRITE;
/*!40000 ALTER TABLE `singer` DISABLE KEYS */
;
INSERT INTO
    `singer`
VALUES (
        1,
        'Liliane Bettencourt',
        1944.0,
        30.0,
        'France'
    ),
    (
        2,
        'Christy Walton',
        1948.0,
        28.8,
        'United States'
    ),
    (
        3,
        'Alice Walton',
        1949.0,
        26.3,
        'United States'
    ),
    (
        4,
        'Iris Fontbona',
        1942.0,
        17.4,
        'Chile'
    ),
    (
        5,
        'Jacqueline Mars',
        1940.0,
        17.8,
        'United States'
    ),
    (
        6,
        'Gina Rinehart',
        1953.0,
        17.0,
        'Australia'
    ),
    (
        7,
        'Susanne Klatten',
        1962.0,
        14.3,
        'Germany'
    ),
    (
        8,
        'Abigail Johnson',
        1961.0,
        12.7,
        'United States'
    );
/*!40000 ALTER TABLE `singer` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `song` (
    `Song_ID` tinyint NOT NULL,
    `Title` varchar(31) DEFAULT NULL,
    `Singer_ID` tinyint DEFAULT NULL,
    `Sales` decimal(8, 1) DEFAULT NULL,
    `Highest_Position` decimal(2, 1) DEFAULT NULL,
    PRIMARY KEY (`Song_ID`),
    CONSTRAINT `song_ibfk_1` FOREIGN KEY (`Singer_ID`) REFERENCES `singer` (`Singer_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */
;
INSERT INTO `song` VALUES (1,'Do They Know It\'s Christmas',1,1094000.0,1.0),(2,'F**k It (I Don\'t Want You Back)',1,552407.0,1.0),(3,'Cha Cha Slide',2,351421.0,1.0),(4,'Call on Me',4,335000.0,1.0),(5,'Yeah',2,300000.0,1.0),(6,'All This Time',6,292000.0,1.0),(7,'Left Outside Alone',5,275000.0,3.0),(8,'Mysterious Girl',7,261000.0,1.0);
/*!40000 ALTER TABLE `song` ENABLE KEYS */
;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */
;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */
;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */
;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */
;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */
;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */
;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */
;

-- Dump completed on 2025-04-11 13:29:56