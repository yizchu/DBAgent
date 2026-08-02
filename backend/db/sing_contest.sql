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
-- Table structure for table `participants`
--

DROP TABLE IF EXISTS `participants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `participants` (
    `id` tinyint NOT NULL,
    `name` varchar(21) DEFAULT NULL,
    `popularity` decimal(4, 2) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `participants`
--

LOCK TABLES `participants` WRITE;
/*!40000 ALTER TABLE `participants` DISABLE KEYS */
;
INSERT INTO
    `participants`
VALUES (1, 'Freeway', 30.71),
    (
        2,
        'Biby Michael\'s Friend',
        7.47
    ),
    (3, 'Iskren Petsov', 5.81),
    (4, 'Sunay Chalakov', 53.11),
    (5, 'Tsetso Vlaykov', 2.90);
/*!40000 ALTER TABLE `participants` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `performance_score`
--

DROP TABLE IF EXISTS `performance_score`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `performance_score` (
    `participant_id` tinyint NOT NULL,
    `songs_id` tinyint NOT NULL,
    `voice_sound_quality` decimal(3, 1) DEFAULT NULL,
    `rhythm_tempo` decimal(3, 1) DEFAULT NULL,
    `stage_presence` decimal(3, 1) DEFAULT NULL,
    PRIMARY KEY (`participant_id`, `songs_id`),
    FOREIGN KEY (`participant_id`) REFERENCES `participants` (`id`),
    FOREIGN KEY (`songs_id`) REFERENCES `songs` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `performance_score`
--

LOCK TABLES `performance_score` WRITE;
/*!40000 ALTER TABLE `performance_score` DISABLE KEYS */
;
INSERT INTO
    `performance_score`
VALUES (1, 13, 10.0, 9.0, 8.0),
    (1, 12, 8.0, 8.0, 8.0),
    (2, 22, 7.0, 4.0, 5.0),
    (2, 23, 2.0, 5.0, 10.0),
    (3, 5, 8.0, 7.0, 8.0),
    (3, 7, 7.0, 10.0, 8.0),
    (4, 18, 9.0, 9.0, 7.0),
    (4, 7, 6.0, 8.0, 9.0),
    (4, 22, 10.0, 10.0, 10.0),
    (5, 25, 9.0, 8.0, 6.0);
/*!40000 ALTER TABLE `performance_score` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `songs`
--

DROP TABLE IF EXISTS `songs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `songs` (
    `id` tinyint NOT NULL,
    `language` varchar(25) DEFAULT NULL,
    `original_artist` varchar(24) DEFAULT NULL,
    `name` varchar(27) DEFAULT NULL,
    `english_translation` varchar(24) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `songs`
--

LOCK TABLES `songs` WRITE;
/*!40000 ALTER TABLE `songs` DISABLE KEYS */
;
INSERT INTO
    `songs`
VALUES (
        1,
        'English , Russian',
        'Sasha Son',
        ' Love ',
        '—'
    ),
    (
        2,
        'English , Hebrew , Arabic',
        'Noa and Mira Awad',
        ' There Must Be Another Way ',
        '—'
    ),
    (
        3,
        'French',
        'Patricia Kaas',
        ' Et s\\\'il fallait le faire ',
        'And if it had to be done'
    ),
    (
        4,
        'French , English',
        'Malena Ernman',
        ' La voix ',
        'The voice'
    ),
    (
        5,
        'Croatian',
        'Igor Cukrov feat. Andrea',
        ' Lijepa Tena ',
        'Beautiful Tena'
    ),
    (
        6,
        'Portuguese',
        'Flor-de-Lis',
        ' Todas as ruas do amor ',
        'All the streets of love'
    ),
    (
        7,
        'English',
        'Yohanna',
        ' Is It True? ',
        '—'
    ),
    (
        8,
        'English',
        'Sakis Rouvas',
        ' This Is Our Night ',
        '—'
    ),
    (
        9,
        'English , Armenian',
        'Inga and Anush',
        ' Jan Jan ',
        'My dear'
    ),
    (
        10,
        'Russian , Ukrainian',
        'Anastasiya Prikhodko',
        ' Mamo (Мамо)',
        'Mum'
    ),
    (
        11,
        'English',
        'AySel and Arash',
        ' Always ',
        '—'
    ),
    (
        12,
        'Bosnian',
        'Regina',
        ' Bistra voda ',
        'Clear water'
    ),
    (
        13,
        'Romanian , English',
        'Nelly Ciobanu',
        ' Hora din Moldova ',
        'Dance from Moldova'
    ),
    (
        14,
        'English',
        'Chiara',
        ' What If We ',
        '—'
    ),
    (
        15,
        'Estonian',
        'Urban Symphony',
        ' Rändajad ',
        'Nomads'
    ),
    (
        16,
        'English',
        'Niels Brinck',
        ' Believe Again ',
        '—'
    ),
    (
        17,
        'English',
        'Alex Swings Oscar Sings!',
        ' Miss Kiss Kiss Bang ',
        '—'
    ),
    (
        18,
        'English',
        'Hadise',
        ' Düm Tek Tek ',
        '— [A]'
    ),
    (
        19,
        'English',
        'Kejsi Tola',
        ' Carry Me in Your Dreams ',
        '—'
    ),
    (
        20,
        'English',
        'Alexander Rybak',
        ' Fairytale ',
        '—'
    ),
    (
        21,
        'English',
        'Svetlana Loboda',
        ' Be My Valentine ',
        '—'
    ),
    (
        22,
        'English',
        'Elena',
        ' The Balkan Girls ',
        '—'
    ),
    (
        23,
        'English',
        'Jade Ewen',
        ' It is My Time ',
        '—'
    ),
    (
        24,
        'English',
        'Waldo\\\'s People',
        ' Lose Control ',
        '—'
    ),
    (
        25,
        'Spanish , English',
        'Soraya Arnelas',
        ' La noche es para mi ',
        'The night is for me'
    );
/*!40000 ALTER TABLE `songs` ENABLE KEYS */
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