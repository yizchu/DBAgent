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
-- Table structure for table `Addresses`
--

DROP TABLE IF EXISTS `Addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Addresses` (
    `address_id` tinyint NOT NULL,
    `line_1` varchar(29) DEFAULT NULL,
    `line_2` varchar(9) DEFAULT NULL,
    `line_3` varchar(0) DEFAULT NULL,
    `city` varchar(16) DEFAULT NULL,
    `zip_postcode` smallint DEFAULT NULL,
    `state_province_county` varchar(13) DEFAULT NULL,
    `country` varchar(15) DEFAULT NULL,
    `other_address_details` varchar(0) DEFAULT NULL,
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
        1,
        '2294 Grant Square Apt. 235',
        'Apt. 370',
        '',
        'Port Chelsea',
        148,
        'Virginia',
        'Iceland',
        ''
    ),
    (
        2,
        '3999 Aufderhar Ways Suite 593',
        'Apt. 388',
        '',
        'Lake Laishafurt',
        943,
        'Kentucky',
        'Burundi',
        ''
    ),
    (
        3,
        '67942 Carlotta Ferry Apt. 686',
        'Apt. 583',
        '',
        'Goodwinhaven',
        541,
        'Kansas',
        'Saudi Arabia',
        ''
    ),
    (
        4,
        '0144 Lamar Plaza Apt. 346',
        'Suite 703',
        '',
        'Port Evanston',
        847,
        'Washington',
        'Angola',
        ''
    ),
    (
        5,
        '858 Peggie Bypass Suite 212',
        'Apt. 335',
        '',
        'Michelleburgh',
        446,
        'Hawaii',
        'Haiti',
        ''
    ),
    (
        6,
        '16998 Mraz Lodge',
        'Apt. 689',
        '',
        'North Omer',
        902,
        'Kentucky',
        'Gibraltar',
        ''
    ),
    (
        7,
        '193 Marlin Brook',
        'Apt. 406',
        '',
        'Herzoghaven',
        68,
        'Arkansas',
        'Cook Islands',
        ''
    ),
    (
        8,
        '202 Hessel Views Apt. 468',
        'Apt. 305',
        '',
        'Mariliehaven',
        638,
        'Idaho',
        'Croatia',
        ''
    ),
    (
        9,
        '0643 Muller Vista',
        'Suite 383',
        '',
        'Port Elvisfurt',
        777,
        'NorthCarolina',
        'Gabon',
        ''
    ),
    (
        10,
        '7081 Eda Center',
        'Suite 830',
        '',
        'Rutherfordtown',
        839,
        'Delaware',
        'Kyrgyz Republic',
        ''
    ),
    (
        11,
        '9283 Schulist Falls Apt. 037',
        'Suite 239',
        '',
        'South Palma',
        400,
        'WestVirginia',
        'Bermuda',
        ''
    ),
    (
        12,
        '979 Haag Shores Suite 656',
        'Apt. 468',
        '',
        'Prohaskafort',
        590,
        'SouthDakota',
        'Lesotho',
        ''
    ),
    (
        13,
        '492 Wilkinson Route',
        'Suite 865',
        '',
        'New Clemensburgh',
        386,
        'Florida',
        'Samoa',
        ''
    ),
    (
        14,
        '186 Evan Motorway Apt. 409',
        'Suite 079',
        '',
        'Lake Careyberg',
        895,
        'Kentucky',
        'New Caledonia',
        ''
    ),
    (
        15,
        '74046 Metz Walk Apt. 113',
        'Suite 674',
        '',
        'Port Oceane',
        669,
        'Wyoming',
        'Norfolk Island',
        ''
    );
/*!40000 ALTER TABLE `Addresses` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Courses`
--

DROP TABLE IF EXISTS `Courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Courses` (
    `course_id` tinyint NOT NULL,
    `course_name` varchar(4) DEFAULT NULL,
    `course_description` varchar(1) DEFAULT NULL,
    `other_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`course_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Courses`
--

LOCK TABLES `Courses` WRITE;
/*!40000 ALTER TABLE `Courses` DISABLE KEYS */
;
INSERT INTO
    `Courses`
VALUES (1, 'ds', 'p', ''),
    (2, 'math', 'q', ''),
    (3, 'os', 'v', ''),
    (4, 'en', 'k', ''),
    (5, 'fr', 'c', ''),
    (6, 'la', 'n', ''),
    (7, 'cal', 'l', ''),
    (8, 'nlp', 'q', ''),
    (9, 'dl', 'l', ''),
    (10, 'ml', 'b', ''),
    (11, 'ai', 'w', ''),
    (12, 'db', 'q', ''),
    (13, 'rs', 'v', ''),
    (14, 'pl', 'p', ''),
    (15, 'oop', 'd', '');
/*!40000 ALTER TABLE `Courses` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Degree_Programs`
--

DROP TABLE IF EXISTS `Degree_Programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Degree_Programs` (
    `degree_program_id` tinyint NOT NULL,
    `department_id` tinyint NOT NULL,
    `degree_summary_name` varchar(8) DEFAULT NULL,
    `degree_summary_description` varchar(10) DEFAULT NULL,
    `other_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`degree_program_id`),
    CONSTRAINT `Degree_Programs_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `Departments` (`department_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Degree_Programs`
--

LOCK TABLES `Degree_Programs` WRITE;
/*!40000 ALTER TABLE `Degree_Programs` DISABLE KEYS */
;
INSERT INTO
    `Degree_Programs`
VALUES (
        1,
        13,
        'Master',
        'architecto',
        ''
    ),
    (2, 2, 'Master', 'cumque', ''),
    (
        3,
        13,
        'Master',
        'placeat',
        ''
    ),
    (4, 8, 'Bachelor', 'unde', ''),
    (
        5,
        11,
        'Master',
        'officiis',
        ''
    ),
    (
        6,
        8,
        'Bachelor',
        'aperiam',
        ''
    ),
    (
        7,
        14,
        'Bachelor',
        'assumenda',
        ''
    ),
    (8, 15, 'Master', 'earum', ''),
    (
        9,
        3,
        'Bachelor',
        'voluptas',
        ''
    ),
    (10, 8, 'Bachelor', 'aut', ''),
    (11, 14, 'Bachelor', 'aut', ''),
    (12, 4, 'Master', 'qui', ''),
    (13, 7, 'Bachelor', 'quam', ''),
    (14, 2, 'PHD', 'et', ''),
    (15, 12, 'PHD', 'esse', '');
/*!40000 ALTER TABLE `Degree_Programs` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Departments`
--

DROP TABLE IF EXISTS `Departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Departments` (
    `department_id` tinyint NOT NULL,
    `department_name` varchar(16) DEFAULT NULL,
    `department_description` varchar(11) DEFAULT NULL,
    `other_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`department_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Departments`
--

LOCK TABLES `Departments` WRITE;
/*!40000 ALTER TABLE `Departments` DISABLE KEYS */
;
INSERT INTO
    `Departments`
VALUES (
        1,
        'computer science',
        'error',
        ''
    ),
    (2, 'history', 'nostrum', ''),
    (3, 'art', 'aliquam', ''),
    (4, 'linguistic', 'natus', ''),
    (5, 'management', 'nihil', ''),
    (6, 'engineer', 'autem', ''),
    (7, 'math', 'doloribus', ''),
    (8, 'statistics', 'nihil', ''),
    (9, 'law', 'dolorem', ''),
    (10, 'economics', 'non', ''),
    (
        11,
        'biology',
        'consequatur',
        ''
    ),
    (12, 'medical', 'ea', ''),
    (
        13,
        'dance',
        'consequatur',
        ''
    ),
    (14, 'drama', 'in', ''),
    (15, 'geography', 'nisi', '');
/*!40000 ALTER TABLE `Departments` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Sections`
--

DROP TABLE IF EXISTS `Sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Sections` (
    `section_id` tinyint NOT NULL,
    `course_id` tinyint NOT NULL,
    `section_name` varchar(1) DEFAULT NULL,
    `section_description` varchar(13) DEFAULT NULL,
    `other_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`section_id`),
    CONSTRAINT `Sections_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Sections`
--

LOCK TABLES `Sections` WRITE;
/*!40000 ALTER TABLE `Sections` DISABLE KEYS */
;
INSERT INTO
    `Sections`
VALUES (1, 9, 'a', 'non', ''),
    (2, 2, 'b', 'voluptatem', ''),
    (3, 8, 'c', 'qui', ''),
    (4, 1, 'd', 'voluptas', ''),
    (5, 5, 'e', 'ex', ''),
    (6, 7, 'f', 'doloremque', ''),
    (7, 12, 'g', 'provident', ''),
    (8, 14, 'h', 'et', ''),
    (9, 8, 'j', 'quis', ''),
    (10, 14, 'k', 'nesciunt', ''),
    (11, 1, 'l', 'ad', ''),
    (12, 4, 'o', 'et', ''),
    (13, 5, 'p', 'facilis', ''),
    (
        14,
        6,
        'u',
        'reprehenderit',
        ''
    ),
    (15, 10, 'y', 'qui', '');
/*!40000 ALTER TABLE `Sections` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Semesters`
--

DROP TABLE IF EXISTS `Semesters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Semesters` (
    `semester_id` tinyint NOT NULL,
    `semester_name` varchar(11) DEFAULT NULL,
    `semester_description` varchar(1) DEFAULT NULL,
    `other_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`semester_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Semesters`
--

LOCK TABLES `Semesters` WRITE;
/*!40000 ALTER TABLE `Semesters` DISABLE KEYS */
;
INSERT INTO
    `Semesters`
VALUES (1, 'spring 2010', 'x', ''),
    (2, 'summer 2010', 'g', ''),
    (3, 'fall 2010', 'w', ''),
    (4, 'winter 2010', 'c', ''),
    (5, 'spring 2018', 'c', ''),
    (6, 'spring 2012', 'l', ''),
    (7, 'spring 2013', 'y', ''),
    (8, 'spring 2014', 'x', ''),
    (9, 'spring 2015', 'x', ''),
    (10, 'spring 2016', 'f', ''),
    (11, 'spring 2017', 'g', ''),
    (12, 'spring 2018', 'm', ''),
    (13, 'fall 2018', 'q', ''),
    (14, 'winter 2018', 't', ''),
    (15, 'spring 2019', 'o', '');
/*!40000 ALTER TABLE `Semesters` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Student_Enrolment`
--

DROP TABLE IF EXISTS `Student_Enrolment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Student_Enrolment` (
    `student_enrolment_id` tinyint NOT NULL,
    `degree_program_id` tinyint NOT NULL,
    `semester_id` tinyint NOT NULL,
    `student_id` tinyint NOT NULL,
    `other_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`student_enrolment_id`),
    CONSTRAINT `Student_Enrolment_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `Students` (`student_id`),
    CONSTRAINT `Student_Enrolment_ibfk_2` FOREIGN KEY (`semester_id`) REFERENCES `Semesters` (`semester_id`),
    CONSTRAINT `Student_Enrolment_ibfk_3` FOREIGN KEY (`degree_program_id`) REFERENCES `Degree_Programs` (`degree_program_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Student_Enrolment`
--

LOCK TABLES `Student_Enrolment` WRITE;
/*!40000 ALTER TABLE `Student_Enrolment` DISABLE KEYS */
;
INSERT INTO
    `Student_Enrolment`
VALUES (1, 12, 13, 14, ''),
    (2, 4, 2, 9, ''),
    (3, 10, 2, 7, ''),
    (4, 4, 15, 9, ''),
    (5, 5, 1, 14, ''),
    (6, 3, 13, 1, ''),
    (7, 9, 9, 4, ''),
    (8, 8, 5, 12, ''),
    (9, 12, 6, 7, ''),
    (10, 11, 2, 7, ''),
    (11, 10, 13, 4, ''),
    (12, 9, 2, 5, ''),
    (13, 2, 12, 6, ''),
    (14, 9, 15, 6, ''),
    (15, 2, 4, 6, '');
/*!40000 ALTER TABLE `Student_Enrolment` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Student_Enrolment_Courses`
--

DROP TABLE IF EXISTS `Student_Enrolment_Courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Student_Enrolment_Courses` (
    `student_course_id` int NOT NULL,
    `course_id` tinyint NOT NULL,
    `student_enrolment_id` tinyint NOT NULL,
    PRIMARY KEY (`student_course_id`),
    CONSTRAINT `Student_Enrolment_Courses_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `Courses` (`course_id`),
    CONSTRAINT `Student_Enrolment_Courses_ibfk_2` FOREIGN KEY (`student_enrolment_id`) REFERENCES `Student_Enrolment` (`student_enrolment_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Student_Enrolment_Courses`
--

LOCK TABLES `Student_Enrolment_Courses` WRITE;
/*!40000 ALTER TABLE `Student_Enrolment_Courses` DISABLE KEYS */
;
INSERT INTO
    `Student_Enrolment_Courses`
VALUES (0, 6, 2),
    (1, 6, 8),
    (2, 14, 5),
    (7, 11, 5),
    (8, 2, 5),
    (76, 10, 13),
    (96, 2, 4),
    (9860, 14, 10),
    (438800, 3, 4),
    (604750, 4, 6),
    (681404, 10, 4),
    (28982908, 8, 9),
    (45105806, 13, 14),
    (70882679, 13, 9),
    (83814225, 12, 14);
/*!40000 ALTER TABLE `Student_Enrolment_Courses` ENABLE KEYS */
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
    `student_id` tinyint NOT NULL,
    `current_address_id` tinyint NOT NULL,
    `permanent_address_id` tinyint NOT NULL,
    `first_name` varchar(8) DEFAULT NULL,
    `middle_name` varchar(8) DEFAULT NULL,
    `last_name` varchar(12) DEFAULT NULL,
    `cell_mobile_number` varchar(19) DEFAULT NULL,
    `email_address` varchar(28) DEFAULT NULL,
    `ssn` varchar(9) DEFAULT NULL,
    `date_first_registered` varchar(0) DEFAULT NULL,
    `date_left` varchar(0) DEFAULT NULL,
    `other_student_details` varchar(10) DEFAULT NULL,
    PRIMARY KEY (`student_id`),
    CONSTRAINT `Students_ibfk_1` FOREIGN KEY (`current_address_id`) REFERENCES `Addresses` (`address_id`),
    CONSTRAINT `Students_ibfk_2` FOREIGN KEY (`permanent_address_id`) REFERENCES `Addresses` (`address_id`)
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
VALUES (
        1,
        10,
        15,
        'Timmothy',
        'Anna',
        'Ward',
        '(096)889-8954x524',
        'erwin.zboncak@example.com',
        '965',
        '',
        '',
        'quia'
    ),
    (
        2,
        12,
        5,
        'Hobart',
        'Lorenz',
        'Balistreri',
        '1-009-710-5151',
        'swift.kolby@example.com',
        '304246',
        '',
        '',
        'autem'
    ),
    (
        3,
        9,
        5,
        'Warren',
        'Violet',
        'Gleichner',
        '07661787471',
        'johns.unique@example.net',
        '3',
        '',
        '',
        'facilis'
    ),
    (
        4,
        7,
        11,
        'Jarvis',
        'Aaliyah',
        'Carroll',
        '09700166582',
        'jillian26@example.net',
        '141072406',
        '',
        '',
        'atque'
    ),
    (
        5,
        9,
        9,
        'Milton',
        'Vaughn',
        'Christiansen',
        '171-642-5684',
        'lhartmann@example.org',
        '',
        '',
        '',
        'laborum'
    ),
    (
        6,
        6,
        3,
        'Stanford',
        'Mona',
        'Rogahn',
        '436.613.7683',
        'skassulke@example.net',
        '248',
        '',
        '',
        'qui'
    ),
    (
        7,
        15,
        3,
        'Frida',
        'Aisha',
        'Huel',
        '1-879-796-8987x164',
        'baumbach.lucious@example.org',
        '668',
        '',
        '',
        'dolorum'
    ),
    (
        8,
        1,
        5,
        'Delaney',
        'Judd',
        'Ankunding',
        '03174364122',
        'dell43@example.net',
        '402',
        '',
        '',
        'voluptatem'
    ),
    (
        9,
        2,
        15,
        'Reva',
        'Golda',
        'Osinski',
        '(507)365-8405',
        'qo\'kon@example.com',
        '39',
        '',
        '',
        'nesciunt'
    ),
    (
        10,
        15,
        14,
        'Helga',
        'Cleve',
        'Mohr',
        '677.401.9382',
        'nya.lesch@example.net',
        '43',
        '',
        '',
        'rerum'
    ),
    (
        11,
        14,
        4,
        'Gregg',
        'Mossie',
        'Schuppe',
        '(462)246-7921',
        'nbruen@example.org',
        '494',
        '',
        '',
        'omnis'
    ),
    (
        12,
        14,
        9,
        'Orrin',
        'Neal',
        'Kemmer',
        '(982)153-1469x1733',
        'beth42@example.org',
        '6274274',
        '',
        '',
        'non'
    ),
    (
        13,
        9,
        8,
        'Deon',
        'Brooklyn',
        'Weimann',
        '(213)445-0399x85208',
        'jhuel@example.com',
        '68095',
        '',
        '',
        'assumenda'
    ),
    (
        14,
        12,
        11,
        'Jordy',
        'Osborne',
        'Rempel',
        '(605)919-3594x3661',
        'gracie29@example.com',
        '34458427',
        '',
        '',
        'et'
    ),
    (
        15,
        2,
        9,
        'Jett',
        'Alberta',
        'Jaskolski',
        '877.549.9067x8723',
        'mya88@example.org',
        '156',
        '',
        '',
        'omnis'
    );
/*!40000 ALTER TABLE `Students` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Transcript_Contents`
--

DROP TABLE IF EXISTS `Transcript_Contents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Transcript_Contents` (
    `student_course_id` int NOT NULL,
    `transcript_id` tinyint NOT NULL,
    CONSTRAINT `Transcript_Contents_ibfk_1` FOREIGN KEY (`student_course_id`) REFERENCES `Student_Enrolment_Courses` (`student_course_id`),
    CONSTRAINT `Transcript_Contents_ibfk_2` FOREIGN KEY (`transcript_id`) REFERENCES `Transcripts` (`transcript_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Transcript_Contents`
--

LOCK TABLES `Transcript_Contents` WRITE;
/*!40000 ALTER TABLE `Transcript_Contents` DISABLE KEYS */
;
INSERT INTO
    `Transcript_Contents`
VALUES (0, 2),
    (96, 8),
    (76, 9),
    (7, 4),
    (0, 15),
    (76, 15),
    (0, 6),
    (96, 13),
    (76, 12),
    (28982908, 11),
    (2, 8),
    (0, 5),
    (8, 5),
    (45105806, 8),
    (70882679, 6);
/*!40000 ALTER TABLE `Transcript_Contents` ENABLE KEYS */
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
    `transcript_id` tinyint NOT NULL,
    `transcript_date` varchar(0) DEFAULT NULL,
    `other_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`transcript_id`)
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
VALUES (1, '', ''),
    (2, '', ''),
    (3, '', ''),
    (4, '', ''),
    (5, '', ''),
    (6, '', ''),
    (7, '', ''),
    (8, '', ''),
    (9, '', ''),
    (10, '', ''),
    (11, '', ''),
    (12, '', ''),
    (13, '', ''),
    (14, '', ''),
    (15, '', '');
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

-- Dump completed on 2025-04-11 13:30:02