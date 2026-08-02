-- 启用外键约束（MySQL 等效写法）
SET FOREIGN_KEY_CHECKS = 1;

-- 创建 author 表
CREATE TABLE `author` (
    `Author_ID` INT,
    `Name` VARCHAR(255),
    `Age` INT,
    `Gender` VARCHAR(255),
    PRIMARY KEY (`Author_ID`)
);

-- 插入 author 数据
INSERT INTO `author` VALUES ( 1, 'Derrick Kosinski', 45, 'Male' );

INSERT INTO `author` VALUES ( 2, 'Evelyn Smith', 32, 'Female' );

INSERT INTO `author` VALUES ( 3, 'Johnny Devenanzio', 54, 'Male' );

INSERT INTO `author` VALUES ( 4, 'Kenny Santucci', 21, 'Male' );

INSERT INTO `author` VALUES ( 5, 'Jenn Grijalva', 19, 'Female' );

INSERT INTO `author` VALUES ( 6, 'Paula Meronek', 23, 'Female' );

INSERT INTO `author` VALUES ( 7, 'Robin Hibbard', 52, 'Female' );

-- 创建 press 表
CREATE TABLE `press` (
    `Press_ID` INT,
    `Name` VARCHAR(255),
    `Month_Profits_billion` REAL,
    `Year_Profits_billion` REAL,
    PRIMARY KEY (`Press_ID`)
);

-- 插入 press 数据
INSERT INTO `press` VALUES (1, 'Accor', 0.65, 6.02);

INSERT INTO `press` VALUES (2, 'Air Liquide', 4.08, 29.49);

INSERT INTO `press` VALUES (3, 'Alstom', 0.96, 9.40);

INSERT INTO `press` VALUES ( 4, 'ArcelorMittal', 1.69, 15.4 );

INSERT INTO `press` VALUES ( 5, 'STMicroelectronics', 0.54, 5.25 );

INSERT INTO `press` VALUES (6, 'Technip', 1.18, 9.24);

INSERT INTO `press` VALUES (7, 'Total', 11.96, 86.94);

INSERT INTO `press` VALUES ( 8, 'Unibail-Rodamco', 2.31, 16.80 );

INSERT INTO `press` VALUES (9, 'Vallourec', 0.58, 4.56);

INSERT INTO `press` VALUES ( 10, 'Veolia Environnement', 0.44, 5.01 );

-- 创建 book 表
CREATE TABLE `book` (
    `Book_ID` INT,
    `Title` VARCHAR(255),
    `Book_Series` VARCHAR(255),
    `Author_ID` INT,
    `Press_ID` INT,
    `Sale_Amount` VARCHAR(255),
    `Release_date` DATE, -- 优化为 MySQL 日期类型（原格式兼容）
    PRIMARY KEY (`Book_ID`),
    FOREIGN KEY (`Author_ID`) REFERENCES `author` (`Author_ID`),
    FOREIGN KEY (`Press_ID`) REFERENCES `press` (`Press_ID`)
);

-- 插入 book 数据
INSERT INTO
    `book`
VALUES (
        1,
        'Book Revue',
        'LT',
        1,
        1,
        '1234',
        '2016-01-05'
    );

INSERT INTO
    `book`
VALUES (
        2,
        'Baseball Bugs',
        'LT',
        2,
        2,
        '1214',
        '2016-02-02'
    );

INSERT INTO
    `book`
VALUES (
        3,
        'Holiday for Shoestrings',
        'MM',
        3,
        3,
        '714',
        '2016-02-23'
    );

INSERT INTO
    `book`
VALUES (
        4,
        'Quentin Quail',
        'MM',
        4,
        4,
        '615',
        '2016-03-02'
    );

INSERT INTO
    `book`
VALUES (
        5,
        'Baby Bottleneck',
        'LT',
        5,
        5,
        '1256',
        '2016-03-16'
    );

INSERT INTO
    `book`
VALUES (
        6,
        'Hare Remover',
        'MM',
        5,
        4,
        '1014',
        '2016-03-23'
    );

INSERT INTO
    `book`
VALUES (
        7,
        'Daffy Doodles',
        'MM',
        1,
        9,
        '1307',
        '2016-04-06'
    );

INSERT INTO
    `book`
VALUES (
        8,
        'Hollywood Canine Canteen',
        'MM',
        1,
        2,
        '1114',
        '2016-04-20'
    );

INSERT INTO
    `book`
VALUES (
        9,
        'Hush My Mouse',
        'LT',
        2,
        3,
        '1258',
        '2016-05-04'
    );

INSERT INTO
    `book`
VALUES (
        10,
        'Hair-Raising Hare',
        'MM',
        5,
        2,
        '115',
        '2016-05-25'
    );