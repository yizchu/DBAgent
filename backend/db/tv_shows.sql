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
-- Table structure for table `city_channel`
--

DROP TABLE IF EXISTS `city_channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `city_channel` (
    `ID` tinyint NOT NULL,
    `City` varchar(26) DEFAULT NULL,
    `Station_name` varchar(7) DEFAULT NULL,
    `Owned_Since` decimal(5, 1) DEFAULT NULL,
    `Affiliation` varchar(14) DEFAULT NULL,
    PRIMARY KEY (`ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `city_channel`
--

LOCK TABLES `city_channel` WRITE;
/*!40000 ALTER TABLE `city_channel` DISABLE KEYS */
;
INSERT INTO
    `city_channel`
VALUES (
        1,
        'Phoenix',
        'KNXV-TV',
        1985.0,
        'ABC'
    ),
    (
        2,
        'Bakersfield, California',
        'KERO-TV',
        2011.0,
        'ABC'
    ),
    (
        3,
        'Bakersfield, California',
        'KZKC-LP',
        2011.0,
        'Azteca América'
    ),
    (
        4,
        'San Diego',
        'KGTV',
        2011.0,
        'ABC'
    ),
    (
        5,
        'San Diego',
        'KZSD-LP',
        2011.0,
        'Azteca América'
    ),
    (
        6,
        'Colorado Springs, Colorado',
        'KZKS-LP',
        2011.0,
        'Azteca América'
    ),
    (
        7,
        'Denver',
        'KMGH-TV',
        2011.0,
        'ABC'
    ),
    (
        8,
        'Denver',
        'KZCO-LP',
        2011.0,
        'Azteca América'
    ),
    (
        9,
        'Fort Collins, Colorado',
        'KZFC-LP',
        2011.0,
        'Azteca América'
    ),
    (
        10,
        'Tampa – St. Petersburg',
        'WFTS-TV',
        1986.0,
        'ABC'
    ),
    (
        11,
        'West Palm Beach',
        'WPTV',
        1961.0,
        'NBC'
    ),
    (
        12,
        'Indianapolis',
        'WRTV',
        2011.0,
        'ABC'
    ),
    (
        13,
        'Baltimore',
        'WMAR-TV',
        1991.0,
        'ABC'
    ),
    (
        14,
        'Detroit',
        'WXYZ-TV',
        1986.0,
        'ABC'
    );
/*!40000 ALTER TABLE `city_channel` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `city_channel_radio`
--

DROP TABLE IF EXISTS `city_channel_radio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `city_channel_radio` (
    `City_channel_ID` tinyint NOT NULL,
    `Radio_ID` tinyint NOT NULL,
    `Is_online` varchar(1) DEFAULT NULL,
    PRIMARY KEY (`City_channel_ID`, `Radio_ID`),
    FOREIGN KEY (`City_channel_ID`) REFERENCES `city_channel` (`ID`),
    FOREIGN KEY (`Radio_ID`) REFERENCES `radio` (`Radio_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `city_channel_radio`
--

LOCK TABLES `city_channel_radio` WRITE;
/*!40000 ALTER TABLE `city_channel_radio` DISABLE KEYS */
;
INSERT INTO
    `city_channel_radio`
VALUES (1, 1, 'T'),
    (2, 2, 'T'),
    (3, 3, 'F'),
    (4, 4, 'T'),
    (10, 1, 'F'),
    (6, 1, 'T'),
    (7, 5, 'F'),
    (8, 3, 'T'),
    (4, 6, 'T'),
    (12, 2, 'F');
/*!40000 ALTER TABLE `city_channel_radio` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `city_channel_tv_show`
--

DROP TABLE IF EXISTS `city_channel_tv_show`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `city_channel_tv_show` (
    `City_channel_ID` tinyint NOT NULL,
    `tv_show_ID` tinyint NOT NULL,
    `Is_online` varchar(1) DEFAULT NULL,
    `Is_free` varchar(1) DEFAULT NULL,
    PRIMARY KEY (
        `City_channel_ID`,
        `tv_show_ID`
    ),
    FOREIGN KEY (`City_channel_ID`) REFERENCES `city_channel` (`ID`),
    FOREIGN KEY (`tv_show_ID`) REFERENCES `tv_show` (`tv_show_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `city_channel_tv_show`
--

LOCK TABLES `city_channel_tv_show` WRITE;
/*!40000 ALTER TABLE `city_channel_tv_show` DISABLE KEYS */
;
INSERT INTO
    `city_channel_tv_show`
VALUES (12, 2, 'T', 'F'),
    (13, 1, 'T', 'F'),
    (14, 1, 'F', 'F'),
    (11, 4, 'T', 'T'),
    (1, 2, 'T', 'F'),
    (2, 3, 'F', 'F'),
    (5, 1, 'T', 'T'),
    (7, 2, 'T', 'T');
/*!40000 ALTER TABLE `city_channel_tv_show` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `radio`
--

DROP TABLE IF EXISTS `radio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `radio` (
    `Radio_ID` tinyint NOT NULL,
    `Transmitter` varchar(14) DEFAULT NULL,
    `Radio_MHz` decimal(3, 1) DEFAULT NULL,
    `2FM_MHz` varchar(4) DEFAULT NULL,
    `RnaG_MHz` varchar(5) DEFAULT NULL,
    `Lyric_FM_MHz` varchar(4) DEFAULT NULL,
    `ERP_kW` decimal(4, 1) DEFAULT NULL,
    PRIMARY KEY (`Radio_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `radio`
--

LOCK TABLES `radio` WRITE;
/*!40000 ALTER TABLE `radio` DISABLE KEYS */
;
INSERT INTO
    `radio`
VALUES (
        1,
        'Cairn Hill',
        89.8,
        'N/A',
        'N/A',
        'N/A',
        16.0
    ),
    (
        2,
        'Clermont Carn',
        87.8,
        '97.0',
        '102.7',
        '95.2',
        40.0
    ),
    (
        3,
        'Kippure',
        89.1,
        '91.3',
        '93.5',
        '98.7',
        40.0
    ),
    (
        4,
        'Maghera',
        88.8,
        '91.0',
        '93.2',
        '98.4',
        160.0
    ),
    (
        5,
        'Mount Leinster',
        89.6,
        '91.8',
        '94.0',
        '99.2',
        100.0
    ),
    (
        6,
        'Mullaghanish',
        90.0,
        '92.2',
        '94.4',
        '99.6',
        160.0
    ),
    (
        7,
        'Three Rock',
        88.5,
        '90.7',
        '92.9',
        '96.7',
        12.5
    );
/*!40000 ALTER TABLE `radio` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `tv_show`
--

DROP TABLE IF EXISTS `tv_show`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `tv_show` (
    `tv_show_ID` tinyint NOT NULL,
    `tv_show_name` varchar(28) DEFAULT NULL,
    `Sub_tittle` varchar(28) DEFAULT NULL,
    `Next_show_name` varchar(23) DEFAULT NULL,
    `Original_Airdate` varchar(16) DEFAULT NULL,
    PRIMARY KEY (`tv_show_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `tv_show`
--

LOCK TABLES `tv_show` WRITE;
/*!40000 ALTER TABLE `tv_show` DISABLE KEYS */
;
INSERT INTO
    `tv_show`
VALUES (
        1,
        'Peace and Quiet',
        'Wanted: Wade',
        'Garfield Goes an Hawaii',
        'September17,1988'
    ),
    (
        2,
        'Box O\' Fun',
        'Unidentified Flying Orson',
        'School Daze',
        'September24,1988'
    ),
    (
        3,
        'Nighty Nightmare',
        'Banana Nose',
        'Ode to Odie',
        'October1,1988'
    ),
    (
        4,
        'Fraidy Cat',
        'Shell Shocked Sheldon',
        'Nothing to Sneeze At',
        'October8,1988'
    ),
    (
        5,
        'Garfield\'s Moving Experience',
        'Wade: You\'re Afraid',
        'Good Mouse-keeping',
        'October15,1988'
    ),
    (
        6,
        'Identity Crisis',
        'The Bad Sport',
        'Up a Tree',
        'October22,1988'
    ),
    (
        7,
        'Weighty Problem',
        'The Worm Turns',
        'Good Cat, Bad Cat',
        'October29,1988'
    ),
    (
        8,
        'Cabin Fever',
        'Return of Power Pig',
        'Fair Exchange',
        'November5,1988'
    ),
    (
        9,
        'The Binky Show',
        'Keeping Cool',
        'Don\'t Move',
        'November12,1988'
    ),
    (
        10,
        'Magic Mutt',
        'Short Story',
        'Monday Misery',
        'November19,1988'
    ),
    (
        11,
        'Best of Breed',
        'National Tapioca Pudding Day',
        'All About Odie',
        'November26,1988'
    ),
    (
        12,
        'Caped Avenger',
        'Shy Fly Guy',
        'Green Thumbs Down',
        'December3,1988'
    );
/*!40000 ALTER TABLE `tv_show` ENABLE KEYS */
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