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
-- Table structure for table `Customers`
--

DROP TABLE IF EXISTS `Customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `Customers` (
    `id` tinyint (4) NOT NULL,
    `name` varchar(9) DEFAULT NULL,
    `age` tinyint (4) DEFAULT NULL,
    `membership_credit` mediumint (9) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Customers`
--

LOCK TABLES `Customers` WRITE;
/*!40000 ALTER TABLE `Customers` DISABLE KEYS */
;
INSERT INTO
    `Customers`
VALUES (1, 'Griffiths', 26, 100),
    (2, 'Silluzio', 34, 1200),
    (3, 'Woodman', 35, 2000),
    (4, 'Poulter', 63, 43500),
    (5, 'Smith', 45, 5399);
/*!40000 ALTER TABLE `Customers` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Discount`
--

DROP TABLE IF EXISTS `Discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `Discount` (
    `id` tinyint (4) NOT NULL,
    `name` varchar(22) DEFAULT NULL,
    `membership_credit` mediumint (9) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Discount`
--

LOCK TABLES `Discount` WRITE;
/*!40000 ALTER TABLE `Discount` DISABLE KEYS */
;
INSERT INTO
    `Discount`
VALUES (1, 'no discount', 0),
    (2, '20% off', 1000),
    (
        3,
        '40% off for over $6000',
        2000
    ),
    (4, '50% off', 4000),
    (5, '70% off', 400000);
/*!40000 ALTER TABLE `Discount` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Renting_history`
--

DROP TABLE IF EXISTS `Renting_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `Renting_history` (
    `id` tinyint (4) NOT NULL,
    `customer_id` tinyint (4) DEFAULT NULL,
    `discount_id` tinyint (4) DEFAULT NULL,
    `vehicles_id` tinyint (4) DEFAULT NULL,
    `total_hours` tinyint (4) DEFAULT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `Renting_history_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `Customers` (`id`),
    CONSTRAINT `Renting_history_ibfk_2` FOREIGN KEY (`discount_id`) REFERENCES `Discount` (`id`),
    CONSTRAINT `Renting_history_ibfk_3` FOREIGN KEY (`vehicles_id`) REFERENCES `Vehicles` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Renting_history`
--

LOCK TABLES `Renting_history` WRITE;
/*!40000 ALTER TABLE `Renting_history` DISABLE KEYS */
;
INSERT INTO
    `Renting_history`
VALUES (1, 1, 1, 2, 1),
    (2, 2, 2, 5, 10),
    (3, 3, 3, 7, 24),
    (4, 4, 4, 3, 24),
    (5, 1, 1, 5, 36),
    (6, 2, 2, 1, 24),
    (7, 5, 4, 4, 72);
/*!40000 ALTER TABLE `Renting_history` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Vehicles`
--

DROP TABLE IF EXISTS `Vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `Vehicles` (
    `id` tinyint (4) NOT NULL,
    `name` varchar(19) DEFAULT NULL,
    `Model_year` smallint (6) DEFAULT NULL,
    `Type_of_powertrain` varchar(8) DEFAULT NULL,
    `Combined_fuel_economy_rate` smallint (6) DEFAULT NULL,
    `City_fuel_economy_rate` smallint (6) DEFAULT NULL,
    `Highway_fuel_economy_rate` smallint (6) DEFAULT NULL,
    `Cost_per_25_miles` decimal(3, 2) DEFAULT NULL,
    `Annual_fuel_cost` decimal(4, 1) DEFAULT NULL,
    `Notes` varchar(24) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Vehicles`
--

LOCK TABLES `Vehicles` WRITE;
/*!40000 ALTER TABLE `Vehicles` DISABLE KEYS */
;
INSERT INTO
    `Vehicles`
VALUES (
        1,
        'Chevrolet Spark EV',
        2014,
        'Electric',
        119,
        128,
        109,
        0.87,
        500.0,
        'See (1)'
    ),
    (
        2,
        'Honda Fit EV',
        2013,
        'hybrid',
        118,
        132,
        105,
        0.87,
        500.0,
        'See (1)'
    ),
    (
        3,
        'Fiat 500e',
        2013,
        'Electric',
        116,
        122,
        108,
        0.87,
        500.0,
        'See (1)'
    ),
    (
        4,
        'Nissan Leaf',
        2013,
        'Electric',
        115,
        129,
        102,
        0.87,
        500.0,
        'See (1)'
    ),
    (
        5,
        'Mitsubishi i',
        2012,
        'hybrid',
        112,
        126,
        99,
        0.90,
        550.0,
        'best selling of the year'
    ),
    (
        6,
        'Ford Focus Electric',
        2012,
        'electric',
        105,
        110,
        99,
        0.96,
        600.0,
        'See (2)'
    ),
    (
        7,
        'BMW ActiveE',
        2011,
        'Electric',
        102,
        107,
        96,
        0.99,
        600.0,
        'See (1)'
    );
/*!40000 ALTER TABLE `Vehicles` ENABLE KEYS */
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