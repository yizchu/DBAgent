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
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `book` (
    `Book_ID` tinyint NOT NULL,
    `Title` varchar(20) DEFAULT NULL,
    `Type` varchar(5) DEFAULT NULL,
    `Pages` smallint DEFAULT NULL,
    `Chapters` tinyint DEFAULT NULL,
    `Audio` varchar(7) DEFAULT NULL,
    `Release` varchar(13) DEFAULT NULL,
    PRIMARY KEY (`Book_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */
;
INSERT INTO
    `book`
VALUES (
        1,
        'A Game of Thrones',
        'Novel',
        704,
        73,
        '33h 53m',
        'August 1996'
    ),
    (
        2,
        'A Clash of Kings',
        'Novel',
        768,
        70,
        '37h 17m',
        'February 1999'
    ),
    (
        3,
        'A Storm of Swords',
        'Novel',
        992,
        82,
        '47h 37m',
        'November 2000'
    ),
    (
        4,
        'A Feast for Crows',
        'Novel',
        753,
        46,
        '31h 10m',
        'November 2005'
    ),
    (
        5,
        'A Dance with Dragons',
        'Poet',
        1056,
        73,
        '48h 56m',
        'July 2011'
    );
/*!40000 ALTER TABLE `book` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `review` (
    `Review_ID` tinyint NOT NULL,
    `Book_ID` tinyint DEFAULT NULL,
    `Rating` decimal(2, 1) DEFAULT NULL,
    `Readers_in_Million` decimal(2, 1) DEFAULT NULL,
    `Rank` tinyint DEFAULT NULL,
    PRIMARY KEY (`Review_ID`),
    FOREIGN KEY (`Book_ID`) REFERENCES `book` (`Book_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */
;
INSERT INTO
    `review`
VALUES (1, 1, 6.6, 3.3, 16),
    (2, 3, 5.7, 2.8, 25),
    (3, 4, 5.8, 2.6, 26),
    (4, 5, 5.6, 2.4, 35);
/*!40000 ALTER TABLE `review` ENABLE KEYS */
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

-- Dump completed on 2025-04-11 13:29:55