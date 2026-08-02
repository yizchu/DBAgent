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
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `matches` (
    `best_of` varchar(10) DEFAULT NULL,
    `draw_size` varchar(10) DEFAULT NULL,
    `loser_age` varchar(10) DEFAULT NULL,
    `loser_entry` varchar(50) DEFAULT NULL,
    `loser_hand` varchar(10) DEFAULT NULL,
    `loser_ht` varchar(10) DEFAULT NULL,
    `loser_id` varchar(50) DEFAULT NULL,
    `loser_ioc` varchar(10) DEFAULT NULL,
    `loser_name` varchar(100) DEFAULT NULL,
    `loser_rank` varchar(10) DEFAULT NULL,
    `loser_rank_points` varchar(20) DEFAULT NULL,
    `loser_seed` varchar(10) DEFAULT NULL,
    `match_num` varchar(20) DEFAULT NULL,
    `minutes` varchar(10) DEFAULT NULL,
    `round` varchar(50) DEFAULT NULL,
    `score` varchar(255) DEFAULT NULL,
    `surface` varchar(50) DEFAULT NULL,
    `tourney_date` varchar(20) DEFAULT NULL,
    `tourney_id` varchar(50) DEFAULT NULL,
    `tourney_level` varchar(10) DEFAULT NULL,
    `tourney_name` varchar(255) DEFAULT NULL,
    `winner_age` varchar(10) DEFAULT NULL,
    `winner_entry` varchar(50) DEFAULT NULL,
    `winner_hand` varchar(10) DEFAULT NULL,
    `winner_ht` varchar(10) DEFAULT NULL,
    `winner_id` varchar(50) DEFAULT NULL,
    `winner_ioc` varchar(10) DEFAULT NULL,
    `winner_name` varchar(100) DEFAULT NULL,
    `winner_rank` varchar(10) DEFAULT NULL,
    `winner_rank_points` varchar(20) DEFAULT NULL,
    `winner_seed` varchar(10) DEFAULT NULL,
    `year` varchar(10) DEFAULT NULL,
    CONSTRAINT `matches_ibfk_1` FOREIGN KEY (`loser_id`) REFERENCES `players` (`player_id`),
    CONSTRAINT `matches_ibfk_2` FOREIGN KEY (`winner_id`) REFERENCES `players` (`player_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;
--
-- Dumping data for table `matches`
--

LOCK TABLES `matches` WRITE;
/*!40000 ALTER TABLE `matches` DISABLE KEYS */
;

/*!40000 ALTER TABLE `matches` ENABLE KEYS */
;

UNLOCK TABLES;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `players` (
    `player_id` varchar(50) NOT NULL,
    `first_name` varchar(100) DEFAULT NULL,
    `last_name` varchar(100) DEFAULT NULL,
    `hand` varchar(10) DEFAULT NULL,
    `birth_date` varchar(20) DEFAULT NULL,
    `country_code` varchar(10) DEFAULT NULL,
    PRIMARY KEY (`player_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `players`
--

LOCK TABLES `players` WRITE;
/*!40000 ALTER TABLE `players` DISABLE KEYS */
;
/*!40000 ALTER TABLE `players` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `rankings`
--

DROP TABLE IF EXISTS `rankings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!50503 SET character_set_client = utf8mb4 */
;
CREATE TABLE `rankings` (
    `ranking_date` varchar(20) DEFAULT NULL,
    `ranking` varchar(10) DEFAULT NULL,
    `player_id` varchar(50) DEFAULT NULL,
    `ranking_points` varchar(20) DEFAULT NULL,
    `tours` varchar(10) DEFAULT NULL,
    CONSTRAINT `rankings_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`player_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `rankings`
--

LOCK TABLES `rankings` WRITE;
/*!40000 ALTER TABLE `rankings` DISABLE KEYS */
;
/*!40000 ALTER TABLE `rankings` ENABLE KEYS */
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