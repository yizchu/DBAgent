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
-- Table structure for table `Other_Available_Features`
--

DROP TABLE IF EXISTS `Other_Available_Features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `Other_Available_Features` (
    `feature_id` tinyint (4) NOT NULL,
    `feature_type_code` varchar(8) NOT NULL,
    `feature_name` varchar(12) DEFAULT NULL,
    `feature_description` varchar(17) DEFAULT NULL,
    PRIMARY KEY (`feature_id`),
    CONSTRAINT `Other_Available_Features_ibfk_1` FOREIGN KEY (`feature_type_code`) REFERENCES `Ref_Feature_Types` (`feature_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Other_Available_Features`
--

LOCK TABLES `Other_Available_Features` WRITE;
/*!40000 ALTER TABLE `Other_Available_Features` DISABLE KEYS */
;
INSERT INTO
    `Other_Available_Features`
VALUES (
        2,
        'Amenity',
        'AirCon',
        'Air Conditioning.'
    ),
    (
        3,
        'Amenity',
        'Pool',
        'Swimming Pool.'
    ),
    (
        4,
        'Security',
        'BurglarAlarm',
        'Burglar Alarm'
    );
/*!40000 ALTER TABLE `Other_Available_Features` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Other_Property_Features`
--

DROP TABLE IF EXISTS `Other_Property_Features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `Other_Property_Features` (
    `property_id` tinyint (4) NOT NULL,
    `feature_id` tinyint (4) NOT NULL,
    `property_feature_description` varchar(9) DEFAULT NULL,
    CONSTRAINT `Other_Property_Features_ibfk_1` FOREIGN KEY (`feature_id`) REFERENCES `Other_Available_Features` (`feature_id`),
    CONSTRAINT `Other_Property_Features_ibfk_2` FOREIGN KEY (`property_id`) REFERENCES `Properties` (`property_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Other_Property_Features`
--

LOCK TABLES `Other_Property_Features` WRITE;
/*!40000 ALTER TABLE `Other_Property_Features` DISABLE KEYS */
;
INSERT INTO
    `Other_Property_Features`
VALUES (15, 3, 'dolorem'),
    (12, 4, 'earum'),
    (6, 2, 'illo'),
    (7, 2, 'hic'),
    (6, 3, 'et'),
    (14, 4, 'quo'),
    (4, 3, 'odio'),
    (1, 2, 'ad'),
    (11, 4, 'vitae'),
    (9, 3, 'quo'),
    (6, 3, 'corrupti'),
    (6, 3, 'doloribus'),
    (13, 2, 'autem'),
    (3, 2, 'cumque'),
    (14, 4, 'modi');
/*!40000 ALTER TABLE `Other_Property_Features` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Properties`
--

DROP TABLE IF EXISTS `Properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `Properties` (
    `property_id` tinyint (4) NOT NULL,
    `property_type_code` varchar(9) NOT NULL,
    `date_on_market` varchar(0) DEFAULT NULL,
    `date_sold` varchar(0) DEFAULT NULL,
    `property_name` varchar(13) DEFAULT NULL,
    `property_address` varchar(60) DEFAULT NULL,
    `room_count` tinyint (4) DEFAULT NULL,
    `vendor_requested_price` decimal(13, 4) DEFAULT NULL,
    `buyer_offered_price` decimal(12, 4) DEFAULT NULL,
    `agreed_selling_price` decimal(13, 4) DEFAULT NULL,
    `apt_feature_1` varchar(11) DEFAULT NULL,
    `apt_feature_2` varchar(8) DEFAULT NULL,
    `apt_feature_3` varchar(0) DEFAULT NULL,
    `fld_feature_1` varchar(0) DEFAULT NULL,
    `fld_feature_2` varchar(0) DEFAULT NULL,
    `fld_feature_3` varchar(0) DEFAULT NULL,
    `hse_feature_1` varchar(0) DEFAULT NULL,
    `hse_feature_2` varchar(0) DEFAULT NULL,
    `hse_feature_3` varchar(0) DEFAULT NULL,
    `oth_feature_1` varchar(0) DEFAULT NULL,
    `oth_feature_2` varchar(0) DEFAULT NULL,
    `oth_feature_3` varchar(0) DEFAULT NULL,
    `shp_feature_1` varchar(0) DEFAULT NULL,
    `shp_feature_2` varchar(0) DEFAULT NULL,
    `shp_feature_3` varchar(0) DEFAULT NULL,
    `other_property_details` varchar(0) DEFAULT NULL,
    PRIMARY KEY (`property_id`),
    CONSTRAINT `Properties_ibfk_1` FOREIGN KEY (`property_type_code`) REFERENCES `Ref_Property_Types` (`property_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Properties`
--

LOCK TABLES `Properties` WRITE;
/*!40000 ALTER TABLE `Properties` DISABLE KEYS */
;
INSERT INTO
    `Properties`
VALUES (
        1,
        'House',
        '',
        '',
        'park',
        '4745 Emerson Stravenue Suite 829\nSouth Garret, IN 16772-5682',
        7,
        372652.2909,
        1.6800,
        4201.8000,
        'aut',
        'suscipit',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        2,
        'House',
        '',
        '',
        'the cole',
        '098 Tremaine Highway Suite 569\nSouth Wilford, NJ 46587-3537',
        1,
        661536468.4429,
        8.7122,
        21769471.8328,
        'est',
        'est',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        3,
        'Other',
        '',
        '',
        'prism',
        '062 Micaela Court Apt. 707\nMargretville, WV 51628-3617',
        8,
        1337.0000,
        11375259.5020,
        5.0000,
        'ut',
        'et',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        4,
        'Field',
        '',
        '',
        'riverside',
        '49578 Ayden Mountains\nNew Russellhaven, UT 46626',
        6,
        192374065.8000,
        15.1700,
        4514.8070,
        'nesciunt',
        'adipisci',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        5,
        'Apartment',
        '',
        '',
        'parc east',
        '2765 Schulist Stream\nLindmouth, UT 03391-3817',
        5,
        983.8596,
        10.1067,
        1.0012,
        'quo',
        'sequi',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        6,
        'Shop',
        '',
        '',
        'high line',
        '6837 Darien Views Apt. 475\nSouth Maraview, KS 77770',
        9,
        2573.0000,
        0.0000,
        476919.3000,
        'sed',
        'culpa',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        7,
        'Shop',
        '',
        '',
        'avalon',
        '092 Paucek Highway Apt. 772\nEast Erika, IA 61358',
        8,
        150045.7568,
        296733.0000,
        2794972.2495,
        'quos',
        'est',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        8,
        'Apartment',
        '',
        '',
        'vogue',
        '24365 Ulices Run\nHomenicktown, MD 88485-6198',
        9,
        13.4715,
        0.0000,
        0.0000,
        'fuga',
        'odio',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        9,
        'Apartment',
        '',
        '',
        'longacre',
        '107 Roob Courts\nErdmanburgh, IA 42926-0873',
        5,
        2219.6778,
        3520911.5258,
        3344706.5755,
        'enim',
        'sit',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        10,
        'Apartment',
        '',
        '',
        'renoir',
        '084 Lakin Vista Apt. 394\nFishertown, MA 16876',
        9,
        77172926.3000,
        1.5509,
        244353758.1824,
        'consequatur',
        'vero',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        11,
        'Other',
        '',
        '',
        'murray hill',
        '2088 Bashirian Fork Suite 337\nFaustinoport, MT 16771-9320',
        2,
        6713620.9000,
        13991131.4340,
        170766.4720,
        'et',
        'est',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        12,
        'Apartment',
        '',
        '',
        'ten tower',
        '743 Ephraim Greens\nAnniemouth, HI 47084-3853',
        5,
        305.0000,
        2.0000,
        456840888.1600,
        'qui',
        'autem',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        13,
        'Other',
        '',
        '',
        'chelsea',
        '60845 Else Highway Apt. 826\nSouth Dougfort, CO 43200-4258',
        2,
        2198735.0950,
        0.0000,
        44132.4621,
        'fuga',
        'aut',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        14,
        'Other',
        '',
        '',
        'wall street',
        '1474 Dibbert Fields Suite 055\nSouth Renee, IN 58286-3097',
        7,
        78.7208,
        2449185.2000,
        0.0000,
        'et',
        'eos',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    ),
    (
        15,
        'Apartment',
        '',
        '',
        'parc coliseum',
        '986 Hagenes Drives\nDraketon, UT 83411-3393',
        3,
        331.0000,
        27537286.0000,
        2574.0000,
        'aut',
        'iusto',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    );
/*!40000 ALTER TABLE `Properties` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Ref_Feature_Types`
--

DROP TABLE IF EXISTS `Ref_Feature_Types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `Ref_Feature_Types` (
    `feature_type_code` varchar(8) NOT NULL,
    `feature_type_name` varchar(27) DEFAULT NULL,
    PRIMARY KEY (`feature_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Ref_Feature_Types`
--

LOCK TABLES `Ref_Feature_Types` WRITE;
/*!40000 ALTER TABLE `Ref_Feature_Types` DISABLE KEYS */
;
INSERT INTO
    `Ref_Feature_Types`
VALUES (
        'Amenity',
        'Amenity, eg Pool.'
    ),
    (
        'Security',
        'Securiyt, eg Burglar Alarm.'
    );
/*!40000 ALTER TABLE `Ref_Feature_Types` ENABLE KEYS */
;
UNLOCK TABLES;

--
-- Table structure for table `Ref_Property_Types`
--

DROP TABLE IF EXISTS `Ref_Property_Types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */
;
/*!40101 SET character_set_client = utf8 */
;
CREATE TABLE `Ref_Property_Types` (
    `property_type_code` varchar(9) NOT NULL,
    `property_type_description` varchar(28) DEFAULT NULL,
    PRIMARY KEY (`property_type_code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 ROW_FORMAT = DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */
;

--
-- Dumping data for table `Ref_Property_Types`
--

LOCK TABLES `Ref_Property_Types` WRITE;
/*!40000 ALTER TABLE `Ref_Property_Types` DISABLE KEYS */
;
INSERT INTO
    `Ref_Property_Types`
VALUES (
        'House',
        'House, Bungalow, etc.'
    ),
    (
        'Apartment',
        'Apartment, Flat, Condo, etc.'
    ),
    ('Field', 'Field, Meadow.'),
    (
        'Other',
        'Other, to be determined.'
    ),
    (
        'Shop',
        'Shop, Retail Outlet.'
    );
/*!40000 ALTER TABLE `Ref_Property_Types` ENABLE KEYS */
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

-- Dump completed on 2025-03-21 19:26:51