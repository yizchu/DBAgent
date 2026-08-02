-- 启用外键约束（MySQL 等效写法）
SET FOREIGN_KEY_CHECKS = 1;

-- 创建 headphone 表（注意：Driver-matched_dB 含连字符，必须用反引号）
CREATE TABLE `headphone` (
    `Headphone_ID` INT,
    `Model` VARCHAR(255),
    `Class` VARCHAR(255),
    `Driver-matched_dB` DOUBLE,
    `Construction` VARCHAR(255),
    `Earpads` VARCHAR(255),
    `Price` INT,
    PRIMARY KEY (`Headphone_ID`)
);

-- 插入 headphone 数据
INSERT INTO
    `headphone`
VALUES (
        1,
        'iGrado',
        'Prestige',
        0.1,
        'Plastic',
        'Comfort Pads',
        49
    );

INSERT INTO
    `headphone`
VALUES (
        2,
        'SR60i',
        'Prestige',
        0.1,
        'Plastic',
        'Comfort Pads',
        79
    );

INSERT INTO
    `headphone`
VALUES (
        3,
        'SR80i',
        'Prestige',
        0.1,
        'Plastic',
        'Comfort Pads',
        99
    );

INSERT INTO
    `headphone`
VALUES (
        4,
        'SR125i',
        'Prestige',
        0.1,
        'Plastic',
        'Comfort Pads',
        150
    );

INSERT INTO
    `headphone`
VALUES (
        5,
        'SR225i',
        'Prestige',
        0.05,
        'Plastic',
        'Bowls',
        200
    );

INSERT INTO
    `headphone`
VALUES (
        6,
        'SR325i',
        'Prestige',
        0.05,
        'Aluminum alloy/ Plastic inner sleeve',
        'Bowls',
        295
    );

INSERT INTO
    `headphone`
VALUES (
        7,
        'RS2i',
        'Reference',
        0.05,
        'Hand-Crafted Mahogany',
        'Bowls',
        495
    );

INSERT INTO
    `headphone`
VALUES (
        8,
        'RS1i',
        'Reference',
        0.05,
        'Hand-Crafted Mahogany',
        'Bowls',
        695
    );

INSERT INTO
    `headphone`
VALUES (
        9,
        'GS1000i',
        'Statement',
        0.05,
        'Hand-Crafted Mahogany',
        'Circumaural Bowls',
        995
    );

INSERT INTO
    `headphone`
VALUES (
        10,
        'PS500',
        'Professional',
        0.05,
        'Hand-Crafted Mahogany / Aluminum',
        'Bowls',
        595
    );

INSERT INTO
    `headphone`
VALUES (
        11,
        'PS1000',
        'Professional',
        0.05,
        'Hand-Crafted Mahogany / Aluminum',
        'Circumaural Bowls',
        1695
    );

-- 创建 store 表
CREATE TABLE `store` (
    `Store_ID` INT,
    `Name` VARCHAR(255),
    `Neighborhood` VARCHAR(255),
    `Parking` VARCHAR(255),
    `Date_Opened` VARCHAR(255),
    PRIMARY KEY (`Store_ID`)
);

-- 插入 store 数据
INSERT INTO
    `store`
VALUES (
        1,
        'Laurel Canyon',
        'Valley Village',
        'None',
        'October 29, 2005'
    );

INSERT INTO
    `store`
VALUES (
        2,
        'Woodman',
        'Valley Glen',
        'None',
        'October 29, 2005'
    );

INSERT INTO
    `store`
VALUES (
        3,
        'Sepulveda',
        'Van Nuys',
        '1,205 Spaces',
        'October 29, 2005'
    );

INSERT INTO
    `store`
VALUES (
        4,
        'Woodley',
        'Van Nuys',
        'None',
        'October 29, 2005'
    );

INSERT INTO
    `store`
VALUES (
        5,
        'Reseda',
        'Tarzana',
        '522 Spaces',
        'October 29, 2005'
    );

INSERT INTO
    `store`
VALUES (
        6,
        'Tampa',
        'Tarzana',
        'n/a',
        'October 29, 2005'
    );

INSERT INTO
    `store`
VALUES (
        7,
        'Pierce College',
        'Winnetka',
        '373 Spaces',
        'October 29, 2005'
    );

INSERT INTO
    `store`
VALUES (
        8,
        'Sherman Way',
        'Canoga Park',
        'Park & Ride Lot',
        'June 30, 2012'
    );

INSERT INTO
    `store`
VALUES (
        9,
        'Roscoe',
        'Canoga Park',
        'None',
        'June 30, 2012'
    );

-- 创建 stock 表
CREATE TABLE `stock` (
    `Store_ID` INT,
    `Headphone_ID` INT,
    `Quantity` INT,
    PRIMARY KEY (`Store_ID`, `Headphone_ID`),
    FOREIGN KEY (`Store_ID`) REFERENCES `store` (`Store_ID`),
    FOREIGN KEY (`Headphone_ID`) REFERENCES `headphone` (`Headphone_ID`)
);

-- 插入 stock 数据
INSERT INTO `stock` VALUES (1, 6, 100);

INSERT INTO `stock` VALUES (2, 2, 170);

INSERT INTO `stock` VALUES (3, 1, 34);

INSERT INTO `stock` VALUES (4, 3, 50);

INSERT INTO `stock` VALUES (5, 5, 100);

INSERT INTO `stock` VALUES (7, 4, 116);

INSERT INTO `stock` VALUES (3, 4, 14);

INSERT INTO `stock` VALUES (2, 3, 300);