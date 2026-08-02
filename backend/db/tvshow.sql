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
-- Table structure for table `Cartoon`
--

DROP TABLE IF EXISTS `Cartoon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `Cartoon` (
    `id` decimal(3, 1) NOT NULL,
    `Title` varchar(33) DEFAULT NULL,
    `Directed_by` varchar(14) DEFAULT NULL,
    `Written_by` varchar(15) DEFAULT NULL,
    `Original_air_date` varchar(15) DEFAULT NULL,
    `Production_code` decimal(4, 1) DEFAULT NULL,
    `Channel` smallint(6) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `Channel` (`Channel`),
    CONSTRAINT `Cartoon_ibfk_1` FOREIGN KEY (`Channel`) REFERENCES `TV_Channel` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Cartoon`
--

LOCK TABLES `Cartoon` WRITE;
/*!40000 ALTER TABLE `Cartoon` DISABLE KEYS */
;
INSERT INTO
    `Cartoon`
VALUES (
        1.0,
        'The Rise of the Blue Beetle!',
        'Ben Jones',
        'Michael Jelenic',
        'November14,2008',
        101.0,
        700
    ),
    (
        2.0,
        'Terror on Dinosaur Island!',
        'Brandon Vietti',
        'Steven Melching',
        'November21,2008',
        102.0,
        701
    ),
    (
        3.0,
        'Evil Under the Sea!',
        'Michael Chang',
        'Joseph Kuhr',
        'December5,2008',
        103.0,
        703
    ),
    (
        4.0,
        'Day of the Dark Knight!',
        'Ben Jones',
        'J. M. DeMatteis',
        'January2,2009',
        104.0,
        704
    ),
    (
        5.0,
        'Invasion of the Secret Santas!',
        'Brandon Vietti',
        'Adam Beechen',
        'December12,2008',
        105.0,
        705
    ),
    (
        6.0,
        'Enter the Outsiders!',
        'Michael Chang',
        'Todd Casey',
        'January9,2009',
        106.0,
        706
    ),
    (
        7.0,
        'Dawn of the Dead Man!',
        'Ben Jones',
        'Steven Melching',
        'January16,2009',
        107.0,
        707
    ),
    (
        8.0,
        'Fall of the Blue Beetle!',
        'Brandon Vietti',
        'James Krieg',
        'January23,2009',
        108.0,
        708
    ),
    (
        9.0,
        'Journey to the Center of the Bat!',
        'Michael Chang',
        'Matt Wayne',
        'January30,2009',
        109.0,
        707
    ),
    (
        10.0,
        'The Eyes of Despero!',
        'Ben Jones',
        'J. M. DeMatteis',
        'February6,2009',
        110.0,
        728
    ),
    (
        11.0,
        'Return of the Fearsome Fangs!',
        'Brandon Vietti',
        'Todd Casey',
        'February20,2009',
        111.0,
        700
    ),
    (
        12.0,
        'Deep Cover for Batman!',
        'Michael Chang',
        'Joseph Kuhr',
        'February27,2009',
        112.0,
        707
    );
/*!40000 ALTER TABLE `Cartoon` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `TV_Channel`
--

DROP TABLE IF EXISTS `TV_Channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `TV_Channel` (
    `id` smallint(6) NOT NULL,
    `series_name` varchar(18) DEFAULT NULL,
    `Country` varchar(14) DEFAULT NULL,
    `Language` varchar(7) DEFAULT NULL,
    `Content` varchar(5) DEFAULT NULL,
    `Pixel_aspect_ratio_PAR` varchar(10) DEFAULT NULL,
    `Hight_definition_TV` varchar(3) DEFAULT NULL,
    `Pay_per_view_PPV` varchar(2) DEFAULT NULL,
    `Package_Option` varchar(21) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `TV_Channel`
--

LOCK TABLES `TV_Channel` WRITE;
/*!40000 ALTER TABLE `TV_Channel` DISABLE KEYS */
;
INSERT INTO
    `TV_Channel`
VALUES (
        700,
        'Sky Radio',
        'Italy',
        'Italian',
        'music',
        '4:3',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        701,
        'Sky Music',
        'Italy',
        'Italian',
        'music',
        '4:3',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        703,
        'Music Box Italia',
        'Italy',
        'Italian',
        'music',
        '4:3 / 16:9',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        704,
        'MTV Hits',
        'Italy',
        'Italian',
        'music',
        '16:9',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        705,
        'MTV Classic',
        'Italy',
        'Italian',
        'music',
        '4:3',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        706,
        'MTV Rocks',
        'United Kingdom',
        'English',
        'music',
        '16:9',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        707,
        'MTV Dance',
        'United Kingdom',
        'English',
        'music',
        '16:9',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        708,
        'MTV Music',
        'Italy',
        'Italian',
        'music',
        '16:9',
        'no',
        'no',
        'no ( FTV )'
    ),
    (
        709,
        'MTV Live HD',
        'Poland',
        'English',
        'music',
        '16:9',
        'yes',
        'no',
        'Sky Famiglia + Sky HD'
    ),
    (
        713,
        'Radio Capital TiVù',
        'Italy',
        'Italian',
        'music',
        '4:3',
        'no',
        'no',
        'no ( FTV )'
    ),
    (
        714,
        'myDeejay',
        'Italy',
        'Italian',
        'music',
        '16:9',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        715,
        'Match Music',
        'Italy',
        'Italian',
        'music',
        '4:3 / 16:9',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        717,
        'Rock TV',
        'Italy',
        'Italian',
        'music',
        '4:3 / 16:9',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        719,
        'Hip Hop TV',
        'Italy',
        'Italian',
        'music',
        '4:3',
        'no',
        'no',
        'Sky Famiglia'
    ),
    (
        728,
        'Classica',
        'Italy',
        'Italian',
        'music',
        '4:3',
        'no',
        'no',
        'Option'
    );
/*!40000 ALTER TABLE `TV_Channel` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `TV_series`
--

DROP TABLE IF EXISTS `TV_series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `TV_series` (
    `id` decimal(3, 1) NOT NULL,
    `Episode` varchar(27) DEFAULT NULL,
    `Air_Date` varchar(18) DEFAULT NULL,
    `Rating` decimal(2, 1) DEFAULT NULL,
    `Share` decimal(2, 1) DEFAULT NULL,
    `18_49_Rating_Share` varchar(5) DEFAULT NULL,
    `Viewers_m` decimal(3, 2) DEFAULT NULL,
    `Weekly_Rank` decimal(3, 1) DEFAULT NULL,
    `Channel` smallint(6) DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `Channel` (`Channel`),
    CONSTRAINT `TV_series_ibfk_1` FOREIGN KEY (`Channel`) REFERENCES `TV_Channel` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `TV_series`
--

LOCK TABLES `TV_series` WRITE;
/*!40000 ALTER TABLE `TV_series` DISABLE KEYS */
;
INSERT INTO
    `TV_series`
VALUES (
        1.0,
        'A Love of a Lifetime',
        'September 24, 2007',
        5.8,
        9.0,
        '3.5/9',
        9.16,
        43.0,
        700
    ),
    (
        2.0,
        'Friendly Skies',
        'October 1, 2007',
        5.3,
        9.0,
        '3.2/8',
        8.23,
        50.0,
        701
    ),
    (
        3.0,
        'Game Three',
        'October 8, 2007',
        4.4,
        7.0,
        '2.9/7',
        6.94,
        61.0,
        707
    ),
    (
        4.0,
        'The Year of the Rabbit',
        'October 15, 2007',
        4.3,
        7.0,
        '2.7/7',
        6.75,
        67.0,
        713
    ),
    (
        5.0,
        'The Legend of Dylan McCleen',
        'October 22, 2007',
        3.8,
        6.0,
        '2.4/6',
        6.06,
        72.0,
        714
    ),
    (
        6.0,
        'Keepers',
        'October 29, 2007',
        3.7,
        6.0,
        '2.2/6',
        5.75,
        71.0,
        700
    ),
    (
        7.0,
        'Double Down',
        'November 5, 2007',
        3.4,
        6.0,
        '2.1/5',
        5.13,
        80.0,
        708
    ),
    (
        8.0,
        'Winterland',
        'November 12, 2007',
        4.0,
        7.0,
        '2.4/6',
        6.09,
        70.0,
        707
    ),
    (
        9.0,
        'Emily',
        'November 19, 2007',
        3.7,
        6.0,
        '2.2/6',
        5.61,
        66.0,
        717
    ),
    (
        10.0,
        'Blowback',
        'November 26, 2007',
        3.7,
        6.0,
        '2.4/6',
        6.05,
        68.0,
        719
    ),
    (
        11.0,
        'Home By Another Way',
        'December 10, 2007',
        3.5,
        6.0,
        '1.7/5',
        5.28,
        62.0,
        728
    ),
    (
        12.0,
        'The Hanged Man',
        'December 17, 2007',
        3.0,
        5.0,
        '1.5/4',
        4.24,
        65.0,
        714
    );
/*!40000 ALTER TABLE `TV_series` ENABLE KEYS */
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

-- Dump completed on 2025-03-21 19:23:30