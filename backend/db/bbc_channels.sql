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
-- Table structure for table `channel`
--

DROP TABLE IF EXISTS `channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `channel` (
    `Channel_ID` tinyint NOT NULL,
    `Name` varchar(12) DEFAULT NULL,
    `Analogue_terrestrial_channel` varchar(11) DEFAULT NULL,
    `Digital_terrestrial_channel` varchar(11) DEFAULT NULL,
    `Internet` varchar(15) DEFAULT NULL,
    PRIMARY KEY (`Channel_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `channel`
--

LOCK TABLES `channel` WRITE;
/*!40000 ALTER TABLE `channel` DISABLE KEYS */
;
INSERT INTO
    `channel`
VALUES (
        1,
        'BBC One',
        '1',
        'HD',
        'bbc.co.uk'
    ),
    (
        2,
        'ITV',
        '3',
        'HD',
        'ITV - itv.com'
    ),
    (
        3,
        'BBC Two',
        '2',
        '2',
        'bbc.co.uk'
    ),
    (
        4,
        'Channel 4',
        '4',
        '8',
        'channel4.com'
    ),
    (
        5,
        'Channel 5',
        '5',
        '44',
        'unavailable'
    ),
    (
        6,
        'ITV3',
        'unavailable',
        '10',
        'itv.com'
    ),
    (
        7,
        'ITV2',
        'unavailable',
        '6',
        'itv.com'
    ),
    (
        8,
        'E4',
        'unavailable',
        '28',
        'e4.com'
    ),
    (
        9,
        'Sky Sports 1',
        'unavailable',
        'unavailable',
        'skysports.com'
    ),
    (
        10,
        'Sky1',
        'unavailable',
        'unavailable',
        'sky.com'
    ),
    (
        11,
        'CBeebies',
        'unavailable',
        '71',
        'bbc.co.uk'
    ),
    (
        12,
        'ITV4',
        'unavailable',
        '24',
        'itv.com'
    ),
    (
        13,
        'BBC Three',
        'unavailable',
        '7',
        'bbc.co.uk'
    ),
    (
        14,
        'Dave',
        'unavailable',
        '12',
        'dave.uktv.co.uk'
    );
/*!40000 ALTER TABLE `channel` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `director`
--

DROP TABLE IF EXISTS `director`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `director` (
    `Director_ID` tinyint NOT NULL,
    `Name` varchar(18) DEFAULT NULL,
    `Age` tinyint DEFAULT NULL,
    PRIMARY KEY (`Director_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `director`
--

LOCK TABLES `director` WRITE;
/*!40000 ALTER TABLE `director` DISABLE KEYS */
;
INSERT INTO
    `director`
VALUES (1, 'DeSean Jackson', 60),
    (2, 'Hank Baskett', 90),
    (3, 'Greg Lewis', 52),
    (4, 'Brent Celek', 44),
    (5, 'Correll Buckhalter', 59),
    (6, 'Reggie Brown', 40),
    (7, 'Brian Westbrook', 47),
    (8, 'Jason Avant', 31),
    (9, 'Kevin Curtis', 32),
    (10, 'L.J. Smith', 43);
/*!40000 ALTER TABLE `director` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `director_admin`
--

DROP TABLE IF EXISTS `director_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `director_admin` (
    `Director_ID` tinyint NOT NULL,
    `Channel_ID` tinyint NOT NULL,
    `Is_first_director` varchar(1) DEFAULT NULL,
    PRIMARY KEY (`Director_ID`, `Channel_ID`),
    FOREIGN KEY (`Channel_ID`) REFERENCES `channel` (`Channel_ID`),
    FOREIGN KEY (`Director_ID`) REFERENCES `director` (`Director_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `director_admin`
--

LOCK TABLES `director_admin` WRITE;
/*!40000 ALTER TABLE `director_admin` DISABLE KEYS */
;
INSERT INTO
    `director_admin`
VALUES (1, 14, 'T'),
    (5, 14, 'F'),
    (3, 14, 'F'),
    (4, 7, 'T'),
    (6, 7, 'F');
/*!40000 ALTER TABLE `director_admin` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `program`
--

DROP TABLE IF EXISTS `program`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `program` (
    `Program_ID` tinyint NOT NULL,
    `Start_Year` decimal(5, 1) DEFAULT NULL,
    `Title` varchar(33) DEFAULT NULL,
    `Director_ID` tinyint DEFAULT NULL,
    `Channel_ID` tinyint DEFAULT NULL,
    PRIMARY KEY (`Program_ID`),
    FOREIGN KEY (`Director_ID`) REFERENCES `director` (`Director_ID`),
    FOREIGN KEY (`Channel_ID`) REFERENCES `channel` (`Channel_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `program`
--

LOCK TABLES `program` WRITE;
/*!40000 ALTER TABLE `program` DISABLE KEYS */
;
INSERT INTO
    `program`
VALUES (
        1,
        2002.0,
        'The Angry Brigade',
        1,
        14
    ),
    (2, 2006.0, 'Dracula', 2, 10),
    (
        3,
        2006.0,
        'Another Country',
        3,
        3
    ),
    (
        4,
        2007.0,
        'Caesar III: An Empire Without End',
        5,
        14
    ),
    (5, 2008.0, 'Othello', 3, 7),
    (
        6,
        2008.0,
        'The Leopard',
        6,
        7
    ),
    (
        7,
        2008.0,
        'Cyrano de Bergerac',
        10,
        14
    ),
    (8, 2009.0, 'Carnival', 9, 10);
/*!40000 ALTER TABLE `program` ENABLE KEYS */
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

-- Dump completed on 2025-04-11 13:29:57