-- 启用外键约束（MySQL 等效写法）
SET FOREIGN_KEY_CHECKS = 1;

-- 创建 district 表
CREATE TABLE `district` (
    `District_ID` INT,
    `Name` VARCHAR(255),
    `Area_km` REAL,
    `Population` REAL,
    `Density_km` REAL,
    `Government_website` VARCHAR(255),
    PRIMARY KEY (`District_ID`)
);

-- 插入 district 数据
INSERT INTO
    `district`
VALUES (
        1,
        'Pozo Almonte',
        13765.8,
        10830,
        0.8,
        'linke.gov'
    );

INSERT INTO
    `district`
VALUES (
        2,
        'Pica',
        8934.3,
        6178,
        0.7,
        'linkd.gov'
    );

INSERT INTO
    `district`
VALUES (
        3,
        'Huara',
        10474.6,
        2599,
        0.2,
        'linka.gov'
    );

INSERT INTO
    `district`
VALUES (
        4,
        'Colchane',
        4015.6,
        1649,
        0.4,
        'linkg.gov'
    );

INSERT INTO
    `district`
VALUES (
        5,
        'Camiña',
        2200.2,
        1275,
        0.6,
        'abc.com'
    );

-- 创建 spokesman 表
CREATE TABLE `spokesman` (
    `Spokesman_ID` INT,
    `Name` VARCHAR(255),
    `Age` INT,
    `Speach_title` VARCHAR(255),
    `Rank_position` REAL,
    `Points` REAL,
    PRIMARY KEY (`Spokesman_ID`)
);

-- 插入 spokesman 数据
INSERT INTO
    `spokesman`
VALUES (
        1,
        'Rocco Granata',
        45,
        'Life and Freedom',
        1,
        498
    );

INSERT INTO
    `spokesman`
VALUES (
        3,
        'Elvis Presley',
        29,
        'Now or Never',
        1,
        438
    );

INSERT INTO
    `spokesman`
VALUES (
        4,
        'Lolita',
        32,
        'Happiness',
        1,
        402
    );

INSERT INTO `spokesman` VALUES (5, 'Connie Francis', 47, 'Everybody\'s Somebody\'s Fool', 1, 365);

INSERT INTO `spokesman` VALUES (6, 'Don Gibson', 46, 'I Can\'t Stop Loving my People', 2, 358);

INSERT INTO `spokesman` VALUES (7, 'Jack Scott', 38, ' What in the World\'s Come Over You', 2, 354);

INSERT INTO
    `spokesman`
VALUES (
        8,
        'Billy Vaughn Orchestra',
        48,
        'Be with the People',
        1,
        350
    );

INSERT INTO
    `spokesman`
VALUES (
        9,
        'Nora Brockstedt',
        36,
        'People',
        1,
        304
    );

INSERT INTO
    `spokesman`
VALUES (
        10,
        'Inger Jacobsen',
        38,
        'Public Health',
        1,
        287
    );

INSERT INTO `spokesman` VALUES (11, 'Bob Luman', 43, 'Let\'s Think About Living', 3, 240);

INSERT INTO
    `spokesman`
VALUES (
        12,
        'Elvis Presley',
        39,
        'Public Health',
        2,
        227
    );

INSERT INTO
    `spokesman`
VALUES (
        13,
        'Roy Orbison',
        34,
        'Freedom',
        4,
        223
    );

-- 创建 spokesman_district 表
CREATE TABLE `spokesman_district` (
    `Spokesman_ID` INT,
    `District_ID` INT,
    `Start_year` VARCHAR(255),
    PRIMARY KEY (`Spokesman_ID`),
    FOREIGN KEY (`Spokesman_ID`) REFERENCES `spokesman` (`Spokesman_ID`),
    FOREIGN KEY (`District_ID`) REFERENCES `district` (`District_ID`)
);

-- 插入 spokesman_district 数据
INSERT INTO `spokesman_district` VALUES (1, 1, '2003');

INSERT INTO `spokesman_district` VALUES (10, 5, '2004');

INSERT INTO `spokesman_district` VALUES (3, 1, '2005');

INSERT INTO `spokesman_district` VALUES (4, 2, '2006');

INSERT INTO `spokesman_district` VALUES (5, 4, '2007');

INSERT INTO `spokesman_district` VALUES (6, 1, '2012');