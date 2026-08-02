-- MySQL dump 10.16  Distrib 10.1.48-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: db
-- ------------------------------------------------------
-- Server version	10.1.48-MariaDB-0+deb9u2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */
;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */
;
/*!40101 SET NAMES utf8mb4 */
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
-- Table structure for table `club`
--

DROP TABLE IF EXISTS `club`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `club` (
    `Club_ID` tinyint(4) NOT NULL,
    `Overall_Ranking` smallint(6) DEFAULT NULL,
    `Team_Leader` varchar(14) DEFAULT NULL,
    `Club_Name` varchar(13) DEFAULT NULL,
    PRIMARY KEY (`Club_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `club`
--

LOCK TABLES `club` WRITE;
/*!40000 ALTER TABLE `club` DISABLE KEYS */
;
INSERT INTO
    `club`
VALUES (
        1,
        5,
        'Mack Mitchell',
        'Houston'
    ),
    (3, 57, 'Oscar Roan', 'SMU'),
    (
        4,
        82,
        'Tony Peters',
        'Oklahoma'
    ),
    (
        5,
        109,
        'John Zimba',
        'Villanova'
    ),
    (
        2,
        119,
        'Jim Cope',
        'Ohio State'
    ),
    (
        6,
        150,
        'Charles Miller',
        'West Virginia'
    ),
    (
        16,
        154,
        'Henry Hynoski',
        'Temple'
    ),
    (7, 161, 'Merle Wang', 'TCU'),
    (
        8,
        186,
        'Barry Santini',
        'Purdue'
    ),
    (
        9,
        213,
        'Larry Poole',
        'Kent State'
    ),
    (
        19,
        215,
        'Floyd Hogan',
        'Arkansas'
    ),
    (
        10,
        238,
        'Stan Lewis',
        'Wayne'
    );
/*!40000 ALTER TABLE `club` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `club_leader`
--

DROP TABLE IF EXISTS `club_leader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `club_leader` (
    `Club_ID` tinyint(4) NOT NULL,
    `Member_ID` smallint(6) NOT NULL,
    `Year_Join` smallint(6) DEFAULT NULL,
    PRIMARY KEY (`Club_ID`, `Member_ID`),
    FOREIGN KEY (`Club_ID`) REFERENCES `club` (`Club_ID`),
    FOREIGN KEY (`Member_ID`) REFERENCES `member` (`Member_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `club_leader`
--

LOCK TABLES `club_leader` WRITE;
/*!40000 ALTER TABLE `club_leader` DISABLE KEYS */
;
INSERT INTO
    `club_leader`
VALUES (1, 1988, 2018),
    (8, 1984, 2017),
    (6, 1985, 2015),
    (4, 1990, 2018),
    (10, 1991, 2017),
    (6, 1999, 2018);
/*!40000 ALTER TABLE `club_leader` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `member` (
    `Member_ID` smallint(6) NOT NULL,
    `Name` varchar(27) DEFAULT NULL,
    `Nationality` varchar(21) DEFAULT NULL,
    `Age` tinyint(4) DEFAULT NULL,
    PRIMARY KEY (`Member_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */
;
INSERT INTO
    `member`
VALUES (
        1984,
        'Wally Lewis',
        'Australia',
        23
    ),
    (
        1985,
        'Brett Kenny',
        'Australia',
        19
    ),
    (
        1986,
        'Garry Jack',
        'Australia',
        18
    ),
    (
        1987,
        'Hugh McGahan Peter Sterling',
        'New Zealand Australia',
        24
    ),
    (
        1988,
        'Ellery Hanley',
        'England',
        19
    ),
    (
        1989,
        'Mal Meninga',
        'Australia',
        22
    ),
    (
        1990,
        'Garry Schofield',
        'England',
        21
    ),
    (
        1991,
        'No award given',
        'No award given',
        20
    ),
    (
        1999,
        'Andrew Johns',
        'Australia',
        19
    ),
    (
        2000,
        'Brad Fittler',
        'Australia',
        17
    );
/*!40000 ALTER TABLE `member` ENABLE KEYS */
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

-- Dump completed on 2025-03-21 19:23:31