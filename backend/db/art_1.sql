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
-- Table structure for table `Artists`
--

DROP TABLE IF EXISTS `Artists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Artists` (
    `artistID` smallint NOT NULL,
    `lname` varchar(8) DEFAULT NULL,
    `fname` varchar(7) DEFAULT NULL,
    `birthYear` smallint DEFAULT NULL,
    `deathYear` smallint DEFAULT NULL,
    PRIMARY KEY (`artistID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Artists`
--

LOCK TABLES `Artists` WRITE;
/*!40000 ALTER TABLE `Artists` DISABLE KEYS */
;
INSERT INTO
    `Artists`
VALUES (
        111,
        'Seurat',
        'Georges',
        1859,
        1891
    ),
    (
        222,
        'Picasso',
        'Pablo',
        1881,
        1973
    ),
    (
        333,
        'van Gogh',
        'Vincent',
        1853,
        1890
    ),
    (
        444,
        'Cassatt',
        'Mary',
        1844,
        1926
    ),
    (
        555,
        'Degas',
        'Edgar',
        1834,
        1917
    );
/*!40000 ALTER TABLE `Artists` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Paintings`
--

DROP TABLE IF EXISTS `Paintings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Paintings` (
    `paintingID` tinyint NOT NULL,
    `title` varchar(67) DEFAULT NULL,
    `year` smallint DEFAULT NULL,
    `height_mm` smallint DEFAULT NULL,
    `width_mm` smallint DEFAULT NULL,
    `medium` varchar(12) DEFAULT NULL,
    `mediumOn` varchar(16) DEFAULT NULL,
    `location` varchar(42) DEFAULT NULL,
    `painterID` smallint DEFAULT NULL,
    PRIMARY KEY (`paintingID`),
    FOREIGN KEY (`painterID`) REFERENCES `Artists` (`artistID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Paintings`
--

LOCK TABLES `Paintings` WRITE;
/*!40000 ALTER TABLE `Paintings` DISABLE KEYS */
;
INSERT INTO `Paintings` VALUES (80,'A Sunday on La Grande Jatte',1884,2076,3080,'oil','canvas','Gallery 240',111),(81,'Final Study for \"Bathers at Asnieres\"',1883,159,251,'oil','panel','Gallery 240',111),(82,'Tree Trunks (study for La Grande Jatte)',1884,474,615,'conte crayon','ivory laid paper','',111),(83,'Abstraction: Background with Blue Cloudy Sky',1930,660,492,'oil','panel','Rice Building Special Exhibition Galleries',222),(84,'Head of Young Girl',1945,271,210,'lithograph','ivory wove paper','',222),(85,'Still Life',1922,816,1006,'oil','canvas','Rice Building Special Exhibition Galleries',222),(86,'A Peasant Woman Digging in Front of Her Cottage',1885,313,419,'oil','canvas','Gallery 241',333),(87,'The Bedroom',1889,313,419,'oil','canvas','Gallery 241',333),(88,'The Drinkers',1890,568,733,'oil','canvas','Gallery 241',333),(89,'Terrace and Observation Deck at the Moulin de Blute-Fin, Montmartre',1887,435,330,'oil','canvas','Gallery 241',333),(90,'On a Balcony',1878,899,652,'oil','canvas','Gallery 273',444),(91,'The Child\'s Bath',1893,1003,661,'oil','canvas','Gallery 273',444),(92,'After the Bullfight',1873,825,640,'oil','canvas','',444),(93,'Cafe Singer',1879,535,418,'oil','canvas','Gallery 226',555);
/*!40000 ALTER TABLE `Paintings` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Sculptures`
--

DROP TABLE IF EXISTS `Sculptures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `Sculptures` (
    `sculptureID` tinyint NOT NULL,
    `title` varchar(13) DEFAULT NULL,
    `year` smallint DEFAULT NULL,
    `medium` varchar(6) DEFAULT NULL,
    `location` varchar(11) DEFAULT NULL,
    `sculptorID` smallint DEFAULT NULL,
    PRIMARY KEY (`sculptureID`),
    FOREIGN KEY (`sculptorID`) REFERENCES `Artists` (`artistID`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Sculptures`
--

LOCK TABLES `Sculptures` WRITE;
/*!40000 ALTER TABLE `Sculptures` DISABLE KEYS */
;
INSERT INTO
    `Sculptures`
VALUES (
        20,
        'Female Figure',
        1945,
        'bronze',
        '',
        222
    ),
    (
        21,
        'Arabesque',
        1885,
        'bronze',
        'Gallery 226',
        555
    ),
    (
        22,
        'Spanish Dance',
        1883,
        'bronze',
        'Gallery 226',
        555
    ),
    (
        23,
        'The Tub',
        1889,
        'bronze',
        'Gallery 226',
        555
    );
/*!40000 ALTER TABLE `Sculptures` ENABLE KEYS */
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