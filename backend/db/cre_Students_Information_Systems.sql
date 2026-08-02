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
-- Table structure for table `Achievements`
--

DROP TABLE IF EXISTS `Achievements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Achievements` (
    `achievement_id` smallint NOT NULL,
    `achievement_type_code` varchar(10) NOT NULL,
    `student_id` smallint NOT NULL,
    `date_achievement` varchar(10) DEFAULT NULL,
    `achievement_details` varchar(6) DEFAULT NULL,
    `other_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`achievement_id`),
    FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`),
    FOREIGN KEY (`achievement_type_code`) REFERENCES `Ref_Achievement_Type` (`achievement_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Achievements`
--

LOCK TABLES `Achievements` WRITE;
/*!40000 ALTER TABLE `Achievements` DISABLE KEYS */
;
INSERT INTO
    `Achievements`
VALUES (
        153,
        'Athletic',
        777,
        '1970-01-01',
        'Gold',
        NULL
    ),
    (
        159,
        'Athletic',
        415,
        '1970-01-01',
        'Gold',
        NULL
    ),
    (
        262,
        'Scholastic',
        415,
        '1970-01-01',
        'Gold',
        NULL
    ),
    (
        264,
        'Scholastic',
        471,
        '1970-01-01',
        'Silver',
        NULL
    ),
    (
        316,
        'Scholastic',
        648,
        '1970-01-01',
        'Gold',
        NULL
    ),
    (
        340,
        'Scholastic',
        276,
        '1970-01-01',
        'Bronze',
        NULL
    ),
    (
        450,
        'Athletic',
        669,
        '1970-01-01',
        'Bronze',
        NULL
    ),
    (
        602,
        'Scholastic',
        824,
        '1970-01-01',
        'Silver',
        NULL
    ),
    (
        650,
        'Athletic',
        777,
        '1970-01-01',
        'Silver',
        NULL
    ),
    (
        672,
        'Athletic',
        984,
        '1970-01-01',
        'Gold',
        NULL
    ),
    (
        697,
        'Scholastic',
        762,
        '1970-01-01',
        'Gold',
        NULL
    ),
    (
        702,
        'Scholastic',
        325,
        '1970-01-01',
        'Gold',
        NULL
    ),
    (
        717,
        'Athletic',
        567,
        '1970-01-01',
        'Silver',
        NULL
    ),
    (
        722,
        'Athletic',
        777,
        '1970-01-01',
        'Silver',
        NULL
    ),
    (
        753,
        'Scholastic',
        325,
        '1970-01-01',
        'Silver',
        NULL
    ),
    (
        770,
        'Athletic',
        287,
        '1970-01-01',
        'Silver',
        NULL
    ),
    (
        877,
        'Athletic',
        471,
        '1970-01-01',
        'Gold',
        NULL
    ),
    (
        885,
        'Scholastic',
        811,
        '1970-01-01',
        'Gold',
        NULL
    ),
    (
        933,
        'Athletic',
        648,
        '1970-01-01',
        'Gold',
        NULL
    ),
    (
        964,
        'Scholastic',
        811,
        '1970-01-01',
        'Gold',
        NULL
    );
/*!40000 ALTER TABLE `Achievements` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Addresses`
--

DROP TABLE IF EXISTS `Addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Addresses` (
    `address_id` tinyint NOT NULL,
    `address_details` varchar(32) NOT NULL,
    PRIMARY KEY (`address_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Addresses`
--

LOCK TABLES `Addresses` WRITE;
/*!40000 ALTER TABLE `Addresses` DISABLE KEYS */
;
INSERT INTO
    `Addresses`
VALUES (
        0,
        '607 Nikita Cape Suite 449'
    ),
    (4, '4474 Dina Park'),
    (5, '19571 Garrett Manor'),
    (
        34,
        '423 Rosenbaum Shores Apt. 812'
    ),
    (47, '100 Hayes Point'),
    (51, '0773 Kaci Villages'),
    (
        66,
        '33376 Terry Mews Suite 922'
    ),
    (
        72,
        '90147 Greenholt Springs Apt. 497'
    ),
    (74, '1951 Beatty Oval'),
    (76, '41082 Calista Mountains'),
    (85, '4240 Enrico Grove'),
    (90, '7127 Ressie Plains'),
    (
        94,
        '222 Chase Union Apt. 747'
    ),
    (97, '564 Aaliyah Trace'),
    (
        98,
        '033 Robel Courts Apt. 312'
    );
/*!40000 ALTER TABLE `Addresses` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Behaviour_Monitoring`
--

DROP TABLE IF EXISTS `Behaviour_Monitoring`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Behaviour_Monitoring` (
    `behaviour_monitoring_id` smallint NOT NULL,
    `student_id` smallint NOT NULL,
    `behaviour_monitoring_details` varchar(1) NOT NULL,
    PRIMARY KEY (`behaviour_monitoring_id`),
    FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Behaviour_Monitoring`
--

LOCK TABLES `Behaviour_Monitoring` WRITE;
/*!40000 ALTER TABLE `Behaviour_Monitoring` DISABLE KEYS */
;
INSERT INTO
    `Behaviour_Monitoring`
VALUES (142, 435, 'A'),
    (220, 811, 'A'),
    (248, 567, 'A'),
    (265, 984, 'B'),
    (376, 648, 'B'),
    (434, 777, 'B'),
    (448, 567, 'C'),
    (477, 287, 'C'),
    (572, 287, 'A'),
    (674, 361, 'C'),
    (701, 669, 'D'),
    (705, 435, 'A'),
    (834, 984, 'E'),
    (873, 325, 'A'),
    (994, 648, 'B');
/*!40000 ALTER TABLE `Behaviour_Monitoring` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Classes`
--

DROP TABLE IF EXISTS `Classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Classes` (
    `class_id` smallint NOT NULL,
    `student_id` smallint NOT NULL,
    `teacher_id` smallint NOT NULL,
    `class_details` varchar(20) NOT NULL,
    PRIMARY KEY (`class_id`),
    FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`),
    FOREIGN KEY (`teacher_id`) REFERENCES `Teachers` (`teacher_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Classes`
--

LOCK TABLES `Classes` WRITE;
/*!40000 ALTER TABLE `Classes` DISABLE KEYS */
;
INSERT INTO
    `Classes`
VALUES (114, 435, 253, 'databases'),
    (195, 471, 274, 'english'),
    (235, 811, 282, 'writing'),
    (248, 471, 252, 'statistics'),
    (294, 762, 234, 'math 100'),
    (354, 287, 302, 'math 300'),
    (
        387,
        325,
        316,
        'statistics 100'
    ),
    (
        411,
        811,
        316,
        'databases 200'
    ),
    (
        424,
        669,
        252,
        'computer science 100'
    ),
    (
        429,
        669,
        195,
        'data structure'
    ),
    (451, 762, 274, 'programming'),
    (455, 471, 274, 'art 300'),
    (493, 824, 252, 'music 100'),
    (
        529,
        567,
        127,
        'computer science 300'
    ),
    (552, 984, 234, 'law 200'),
    (553, 762, 226, 'art 100'),
    (579, 276, 282, 'debate'),
    (600, 361, 195, 'networks'),
    (613, 435, 212, 'dancing'),
    (621, 811, 234, 'acting');
/*!40000 ALTER TABLE `Classes` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Detention`
--

DROP TABLE IF EXISTS `Detention`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Detention` (
    `detention_id` smallint NOT NULL,
    `detention_type_code` varchar(12) NOT NULL,
    `student_id` smallint NOT NULL,
    `datetime_detention_start` varchar(10) DEFAULT NULL,
    `datetime_detention_end` varchar(10) DEFAULT NULL,
    `detention_summary` varchar(0) DEFAULT NULL,
    `other_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`detention_id`),
    FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`),
    FOREIGN KEY (`detention_type_code`) REFERENCES `Ref_Detention_Type` (`detention_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Detention`
--

LOCK TABLES `Detention` WRITE;
/*!40000 ALTER TABLE `Detention` DISABLE KEYS */
;
INSERT INTO
    `Detention`
VALUES (
        133,
        'Lunch',
        361,
        '2012-03-18',
        '2011-09-15',
        NULL,
        NULL
    ),
    (
        141,
        'After School',
        811,
        '2012-06-07',
        '2009-05-23',
        NULL,
        NULL
    ),
    (
        211,
        'Break',
        762,
        '2011-04-24',
        '2013-09-06',
        NULL,
        NULL
    ),
    (
        242,
        'After School',
        648,
        '2014-01-16',
        '2013-04-07',
        NULL,
        NULL
    ),
    (
        384,
        'Illness',
        762,
        '2016-12-28',
        '2013-04-20',
        NULL,
        NULL
    ),
    (
        401,
        'Break',
        415,
        '2011-03-22',
        '2013-10-06',
        NULL,
        NULL
    ),
    (
        451,
        'After School',
        361,
        '2014-02-03',
        '2012-05-09',
        NULL,
        NULL
    ),
    (
        478,
        'Illness',
        762,
        '2010-03-14',
        '2015-10-16',
        NULL,
        NULL
    ),
    (
        492,
        'Break',
        471,
        '2018-03-16',
        '2008-06-03',
        NULL,
        NULL
    ),
    (
        545,
        'Illness',
        276,
        '2013-06-24',
        '2014-05-18',
        NULL,
        NULL
    ),
    (
        576,
        'After School',
        471,
        '2010-08-24',
        '2015-12-13',
        NULL,
        NULL
    ),
    (
        646,
        'Illness',
        984,
        '2017-08-12',
        '2013-12-02',
        NULL,
        NULL
    ),
    (
        796,
        'Illness',
        415,
        '2010-08-16',
        '2013-10-18',
        NULL,
        NULL
    ),
    (
        804,
        'After School',
        648,
        '2015-07-11',
        '2014-10-14',
        NULL,
        NULL
    ),
    (
        860,
        'Illness',
        435,
        '2009-07-29',
        '2016-06-03',
        NULL,
        NULL
    ),
    (
        868,
        'Illness',
        435,
        '2017-01-09',
        '2016-06-03',
        NULL,
        NULL
    ),
    (
        876,
        'After School',
        669,
        '2008-04-12',
        '2009-10-12',
        NULL,
        NULL
    ),
    (
        904,
        'Break',
        648,
        '2013-03-02',
        '2010-11-06',
        NULL,
        NULL
    ),
    (
        907,
        'After School',
        762,
        '2011-03-27',
        '2015-01-29',
        NULL,
        NULL
    ),
    (
        962,
        'After School',
        435,
        '2011-05-19',
        '2015-12-14',
        NULL,
        NULL
    );
/*!40000 ALTER TABLE `Detention` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Ref_Achievement_Type`
--

DROP TABLE IF EXISTS `Ref_Achievement_Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Ref_Achievement_Type` (
    `achievement_type_code` varchar(10) NOT NULL,
    `achievement_type_description` varchar(10) DEFAULT NULL,
    PRIMARY KEY (`achievement_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Ref_Achievement_Type`
--

LOCK TABLES `Ref_Achievement_Type` WRITE;
/*!40000 ALTER TABLE `Ref_Achievement_Type` DISABLE KEYS */
;
INSERT INTO
    `Ref_Achievement_Type`
VALUES ('Athletic', 'Athletic'),
    ('Scholastic', 'Scholastic');
/*!40000 ALTER TABLE `Ref_Achievement_Type` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Ref_Address_Types`
--

DROP TABLE IF EXISTS `Ref_Address_Types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Ref_Address_Types` (
    `address_type_code` varchar(2) NOT NULL,
    `address_type_description` varchar(7) NOT NULL,
    PRIMARY KEY (`address_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Ref_Address_Types`
--

LOCK TABLES `Ref_Address_Types` WRITE;
/*!40000 ALTER TABLE `Ref_Address_Types` DISABLE KEYS */
;
INSERT INTO
    `Ref_Address_Types`
VALUES ('CO', 'College'),
    ('HM', 'Home');
/*!40000 ALTER TABLE `Ref_Address_Types` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Ref_Detention_Type`
--

DROP TABLE IF EXISTS `Ref_Detention_Type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Ref_Detention_Type` (
    `detention_type_code` varchar(12) NOT NULL,
    `detention_type_description` varchar(17) DEFAULT NULL,
    PRIMARY KEY (`detention_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Ref_Detention_Type`
--

LOCK TABLES `Ref_Detention_Type` WRITE;
/*!40000 ALTER TABLE `Ref_Detention_Type` DISABLE KEYS */
;
INSERT INTO
    `Ref_Detention_Type`
VALUES (
        'After School',
        'After School'
    ),
    ('Break', 'On break'),
    (
        'Illness',
        'Leave for illness'
    ),
    ('Lunch', 'During lunchtime');
/*!40000 ALTER TABLE `Ref_Detention_Type` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Ref_Event_Types`
--

DROP TABLE IF EXISTS `Ref_Event_Types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Ref_Event_Types` (
    `event_type_code` varchar(12) NOT NULL,
    `event_type_description` varchar(12) NOT NULL,
    PRIMARY KEY (`event_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Ref_Event_Types`
--

LOCK TABLES `Ref_Event_Types` WRITE;
/*!40000 ALTER TABLE `Ref_Event_Types` DISABLE KEYS */
;
INSERT INTO
    `Ref_Event_Types`
VALUES ('Exam', 'Exam'),
    (
        'Registration',
        'Registration'
    );
/*!40000 ALTER TABLE `Ref_Event_Types` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Student_Events`
--

DROP TABLE IF EXISTS `Student_Events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Student_Events` (
    `event_id` smallint NOT NULL,
    `event_type_code` varchar(12) NOT NULL,
    `student_id` smallint NOT NULL,
    `event_date` varchar(10) DEFAULT NULL,
    `other_details` varchar(0) NOT NULL,
    PRIMARY KEY (`event_id`),
    FOREIGN KEY (`event_type_code`) REFERENCES `Ref_Event_Types` (`event_type_code`),
    FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Student_Events`
--

LOCK TABLES `Student_Events` WRITE;
/*!40000 ALTER TABLE `Student_Events` DISABLE KEYS */
;
INSERT INTO
    `Student_Events`
VALUES (
        146,
        'Exam',
        287,
        '2008-08-15',
        NULL
    ),
    (
        161,
        'Exam',
        777,
        '2014-07-15',
        NULL
    ),
    (
        189,
        'Exam',
        361,
        '2013-04-14',
        NULL
    ),
    (
        227,
        'Registration',
        669,
        '2012-12-06',
        NULL
    );
/*!40000 ALTER TABLE `Student_Events` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Student_Loans`
--

DROP TABLE IF EXISTS `Student_Loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Student_Loans` (
    `student_loan_id` smallint NOT NULL,
    `student_id` smallint NOT NULL,
    `date_of_loan` varchar(10) DEFAULT NULL,
    `amount_of_loan` decimal(6, 2) DEFAULT NULL,
    `other_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`student_loan_id`),
    FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Student_Loans`
--

LOCK TABLES `Student_Loans` WRITE;
/*!40000 ALTER TABLE `Student_Loans` DISABLE KEYS */
;
INSERT INTO
    `Student_Loans`
VALUES (
        165,
        777,
        '1980-01-06',
        2216.15,
        NULL
    ),
    (
        169,
        669,
        '1991-03-24',
        5223.18,
        NULL
    ),
    (
        188,
        777,
        '1983-08-01',
        3221.49,
        NULL
    ),
    (
        205,
        777,
        '1977-08-27',
        3358.87,
        NULL
    ),
    (
        267,
        435,
        '2018-01-17',
        5174.76,
        NULL
    ),
    (
        269,
        361,
        '1989-05-07',
        3803.60,
        NULL
    ),
    (
        287,
        984,
        '1989-04-23',
        1561.57,
        NULL
    ),
    (
        366,
        361,
        '1992-11-14',
        4190.32,
        NULL
    ),
    (
        408,
        762,
        '1994-02-24',
        4213.13,
        NULL
    ),
    (
        550,
        762,
        '2004-04-11',
        1644.65,
        NULL
    ),
    (
        574,
        325,
        '1975-07-21',
        1419.97,
        NULL
    ),
    (
        596,
        824,
        '1978-08-01',
        4454.30,
        NULL
    ),
    (
        652,
        984,
        '2001-07-31',
        4407.27,
        NULL
    ),
    (
        684,
        415,
        '1993-11-23',
        3768.49,
        NULL
    ),
    (
        718,
        325,
        '1981-05-31',
        2312.53,
        NULL
    ),
    (
        824,
        824,
        '2012-11-19',
        1785.44,
        NULL
    ),
    (
        837,
        984,
        '1994-02-10',
        2645.76,
        NULL
    ),
    (
        850,
        287,
        '1973-10-22',
        5006.94,
        NULL
    ),
    (
        889,
        567,
        '2014-01-06',
        3685.74,
        NULL
    ),
    (
        965,
        824,
        '1983-05-03',
        4528.50,
        NULL
    );
/*!40000 ALTER TABLE `Student_Loans` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Students`
--

DROP TABLE IF EXISTS `Students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Students` (
    `student_id` smallint NOT NULL,
    `bio_data` varchar(8) NOT NULL,
    `student_details` varchar(9) NOT NULL,
    PRIMARY KEY (`student_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Students`
--

LOCK TABLES `Students` WRITE;
/*!40000 ALTER TABLE `Students` DISABLE KEYS */
;
INSERT INTO
    `Students`
VALUES (276, 'Camila', 'Suite 076'),
    (287, 'Dino', 'Suite 970'),
    (325, 'Pansy', 'Apt. 149'),
    (361, 'Louvenia', 'Suite 218'),
    (415, 'Leora', 'Apt. 748'),
    (435, 'Vanessa', 'Suite 684'),
    (471, 'Antone', 'Suite 303'),
    (567, 'Arturo', 'Apt. 491'),
    (648, 'Leonard', 'Suite 505'),
    (669, 'Brenden', 'Apt. 305'),
    (762, 'Edison', 'Apt. 763'),
    (777, 'Houston', 'Apt. 040'),
    (811, 'Felipa', 'Apt. 253'),
    (824, 'Stephon', 'Suite 839'),
    (984, 'Keshawn', 'Suite 889');
/*!40000 ALTER TABLE `Students` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Students_Addresses`
--

DROP TABLE IF EXISTS `Students_Addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Students_Addresses` (
    `student_address_id` tinyint NOT NULL,
    `address_id` tinyint NOT NULL,
    `address_type_code` varchar(2) NOT NULL,
    `student_id` smallint NOT NULL,
    `date_from` varchar(10) DEFAULT NULL,
    `date_to` varchar(10) DEFAULT NULL,
    PRIMARY KEY (`student_address_id`),
    FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`),
    FOREIGN KEY (`address_id`) REFERENCES `Addresses` (`address_id`),
    FOREIGN KEY (`address_type_code`) REFERENCES `Ref_Address_Types` (`address_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Students_Addresses`
--

LOCK TABLES `Students_Addresses` WRITE;
/*!40000 ALTER TABLE `Students_Addresses` DISABLE KEYS */
;
INSERT INTO
    `Students_Addresses`
VALUES (
        11,
        94,
        'HM',
        984,
        '2011-06-29',
        '2018-03-22'
    ),
    (
        15,
        76,
        'HM',
        415,
        '2011-10-04',
        '2018-03-14'
    ),
    (
        20,
        97,
        'CO',
        777,
        '2015-02-01',
        '2018-03-04'
    ),
    (
        23,
        72,
        'CO',
        361,
        '2015-03-14',
        '2018-03-08'
    ),
    (
        33,
        97,
        'HM',
        762,
        '2017-05-18',
        '2018-03-20'
    ),
    (
        35,
        98,
        'HM',
        762,
        '2009-04-27',
        '2018-02-28'
    ),
    (
        45,
        90,
        'HM',
        777,
        '2014-03-28',
        '2018-03-11'
    ),
    (
        56,
        94,
        'HM',
        777,
        '2009-08-24',
        '2018-03-10'
    ),
    (
        59,
        98,
        'HM',
        777,
        '2013-05-27',
        '2018-02-27'
    ),
    (
        67,
        0,
        'HM',
        361,
        '2011-04-29',
        '2018-03-02'
    ),
    (
        73,
        34,
        'CO',
        471,
        '2008-04-20',
        '2018-03-18'
    ),
    (
        80,
        85,
        'HM',
        471,
        '2009-02-23',
        '2018-03-06'
    ),
    (
        84,
        76,
        'HM',
        415,
        '2008-09-21',
        '2018-03-03'
    ),
    (
        91,
        66,
        'HM',
        276,
        '2012-12-17',
        '2018-03-22'
    ),
    (
        92,
        97,
        'HM',
        361,
        '2009-06-21',
        '2018-03-04'
    );
/*!40000 ALTER TABLE `Students_Addresses` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Teachers`
--

DROP TABLE IF EXISTS `Teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Teachers` (
    `teacher_id` smallint NOT NULL,
    `teacher_details` varchar(9) DEFAULT NULL,
    PRIMARY KEY (`teacher_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Teachers`
--

LOCK TABLES `Teachers` WRITE;
/*!40000 ALTER TABLE `Teachers` DISABLE KEYS */
;
INSERT INTO
    `Teachers`
VALUES (115, 'Jon'),
    (127, 'Tyson'),
    (164, 'Trinity'),
    (172, 'Viva'),
    (195, 'Osvaldo'),
    (212, 'Isabel'),
    (226, 'Adella'),
    (234, 'Chasity'),
    (252, 'Wilfredo'),
    (253, 'Marielle'),
    (274, 'Beverly'),
    (282, 'Nicholaus'),
    (298, 'Arianna'),
    (302, 'Angie'),
    (316, 'Hertha');
/*!40000 ALTER TABLE `Teachers` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Transcripts`
--

DROP TABLE IF EXISTS `Transcripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Transcripts` (
    `transcript_id` smallint NOT NULL,
    `student_id` smallint NOT NULL,
    `date_of_transcript` varchar(10) DEFAULT NULL,
    `transcript_details` varchar(4) NOT NULL,
    PRIMARY KEY (`transcript_id`),
    FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Transcripts`
--

LOCK TABLES `Transcripts` WRITE;
/*!40000 ALTER TABLE `Transcripts` DISABLE KEYS */
;
INSERT INTO
    `Transcripts`
VALUES (
        131,
        669,
        '1973-08-09',
        'Good'
    ),
    (
        138,
        824,
        '1973-11-05',
        'Good'
    ),
    (
        145,
        361,
        '2002-11-23',
        'Good'
    ),
    (
        167,
        276,
        '2017-03-17',
        'Pass'
    ),
    (
        177,
        811,
        '2010-12-14',
        'Good'
    ),
    (
        224,
        567,
        '1973-05-05',
        'Pass'
    ),
    (
        264,
        824,
        '2005-06-04',
        'Good'
    ),
    (
        276,
        415,
        '2002-02-26',
        'Pass'
    ),
    (
        283,
        287,
        '1979-04-05',
        'Good'
    ),
    (
        293,
        276,
        '2017-10-31',
        'Pass'
    ),
    (
        307,
        648,
        '1981-12-01',
        'Good'
    ),
    (
        309,
        777,
        '1979-02-07',
        'Pass'
    ),
    (
        325,
        361,
        '2015-07-24',
        'Good'
    ),
    (
        330,
        669,
        '2014-09-13',
        'Pass'
    ),
    (
        377,
        984,
        '1982-12-04',
        'Pass'
    );
/*!40000 ALTER TABLE `Transcripts` ENABLE KEYS */
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

-- Dump completed on 2025-04-11 13:30:03