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
-- Table structure for table `driver`
--

DROP TABLE IF EXISTS `driver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `driver` (
    `Driver_ID` tinyint NOT NULL,
    `Driver_Name` varchar(27) DEFAULT NULL,
    `Entrant` varchar(26) DEFAULT NULL,
    `Constructor` varchar(13) DEFAULT NULL,
    `Chassis` varchar(19) DEFAULT NULL,
    `Engine` varchar(6) DEFAULT NULL,
    `Age` tinyint DEFAULT NULL,
    PRIMARY KEY (`Driver_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `driver`
--

LOCK TABLES `driver` WRITE;
/*!40000 ALTER TABLE `driver` DISABLE KEYS */
;
INSERT INTO
    `driver`
VALUES (
        1,
        'Ernst-Günther Burggaller',
        'German Bugatti Team',
        'Bugatti',
        'Bugatti T35B',
        '2.3 L8',
        18
    ),
    (
        2,
        'Hermann zu Leiningen',
        'German Bugatti Team',
        'Bugatti',
        'Bugatti T35C',
        '2.0 L8',
        20
    ),
    (
        3,
        'Heinrich-Joachim von Morgen',
        'German Bugatti Team',
        'Bugatti',
        'Bugatti T35B',
        '2.3 L8',
        23
    ),
    (
        4,
        'Rudolf Caracciola',
        'Private entry',
        'Mercedes-Benz',
        'Mercedes-Benz SSK L',
        '7.1 L6',
        24
    ),
    (
        5,
        'Earl Howe',
        'Private entry',
        'Bugatti',
        'Bugatti T51',
        '2.3 L8',
        26
    ),
    (
        6,
        'Clifton Penn-Hughes',
        'Private entry',
        'Bugatti',
        'Bugatti T35',
        '2.0 L8',
        21
    ),
    (
        7,
        'Henry Birkin',
        'Private entry',
        'Maserati',
        'Maserati 26M',
        '2.5 L8',
        28
    ),
    (
        8,
        'Bernhard Ackerl',
        'Private entry',
        'Bugatti',
        'Bugatti T37',
        '1.5 L4',
        29
    ),
    (
        9,
        'Juan Zanelli',
        'Private entry',
        'Bugatti',
        'Bugatti T35B',
        '2.3 L8',
        26
    ),
    (
        10,
        'Guy Bouriat',
        'Automobiles Ettore Bugatti',
        'Bugatti',
        'Bugatti T51',
        '2.3 L8',
        28
    ),
    (
        11,
        'Louis Chiron',
        'Automobiles Ettore Bugatti',
        'Bugatti',
        'Bugatti T51',
        '2.3 L8',
        35
    );
/*!40000 ALTER TABLE `driver` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `race`
--

DROP TABLE IF EXISTS `race`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `race` (
    `Road` tinyint NOT NULL,
    `Driver_ID` tinyint DEFAULT NULL,
    `Race_Name` varchar(40) DEFAULT NULL,
    `Pole_Position` varchar(17) DEFAULT NULL,
    `Fastest_Lap` varchar(18) DEFAULT NULL,
    `Winning_driver` varchar(18) DEFAULT NULL,
    `Winning_team` varchar(25) DEFAULT NULL,
    `Report` varchar(6) DEFAULT NULL,
    PRIMARY KEY (`Road`),
    FOREIGN KEY (`Driver_ID`) REFERENCES `driver` (`Driver_ID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `race`
--

LOCK TABLES `race` WRITE;
/*!40000 ALTER TABLE `race` DISABLE KEYS */
;
INSERT INTO
    `race`
VALUES (
        2,
        1,
        'Monterey Festival of Speed',
        'James Hinchcliffe',
        'Douglas Soares',
        'James Hinchcliffe',
        'Forsythe Pettit Racing',
        'Report'
    ),
    (
        3,
        2,
        'Sommet des Legends',
        'Junior Strous',
        'Junior Strous',
        'Junior Strous',
        'Condor Motorsports',
        'Report'
    ),
    (
        4,
        1,
        'Rexall Grand Prix of Edmonton - Race 1',
        'James Hinchcliffe',
        'David Garza Pérez',
        'Jonathan Bomarito',
        'Mathiasen Motorsports',
        'Report'
    ),
    (
        5,
        3,
        'Rexall Grand Prix of Edmonton - Race 2',
        'Carl Skerlong',
        'Carl Skerlong',
        'Jonathan Summerton',
        'Newman Wachs Racing',
        'Report'
    ),
    (
        6,
        4,
        'Road Race Showcase/Road America - Race 1',
        'Dane Cameron',
        'Tõnis Kasemets',
        'Jonathan Bomarito',
        'Mathiasen Motorsports',
        'Report'
    ),
    (
        7,
        9,
        'Road Race Showcase/Road America - Race 2',
        'Jonathan Bomarito',
        'Dane Cameron',
        'Jonathan Summerton',
        'Newman Wachs Racing',
        'Report'
    ),
    (
        8,
        10,
        'Grand Prix de Trois-Rivières',
        'Jonathan Bomarito',
        'Jonathan Summerton',
        'Jonathan Bomarito',
        'Mathiasen Motorsports',
        'Report'
    ),
    (
        9,
        1,
        'Mazda Formula Zoom Zoom',
        'Carl Skerlong',
        'Carl Skerlong',
        'Carl Skerlong',
        'Pacific Coast Motorsports',
        'Report'
    ),
    (
        10,
        2,
        'SunRichGourmet.com 1000',
        'Markus Niemelä',
        'Carl Skerlong',
        'Markus Niemelä',
        'Brooks Associates Racing',
        'Report'
    );
/*!40000 ALTER TABLE `race` ENABLE KEYS */
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