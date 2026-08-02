-- 启用外键约束（MySQL 默认启用，显式声明确保兼容性）
SET FOREIGN_KEY_CHECKS = 1;

-- 创建 languages 表
CREATE TABLE `languages` (
    `id` INT NOT NULL,
    `name` TEXT,
    PRIMARY KEY (`id`)
);

-- 插入 languages 数据
INSERT INTO `languages` VALUES (1, 'Icelandic');

INSERT INTO `languages` VALUES (2, 'Swedish');

INSERT INTO `languages` VALUES (3, 'English');

INSERT INTO `languages` VALUES (4, 'Danish');

INSERT INTO `languages` VALUES (5, 'Finnish');

INSERT INTO `languages` VALUES (6, 'German');

INSERT INTO `languages` VALUES (7, 'French');

INSERT INTO `languages` VALUES (8, 'Norwegian');

INSERT INTO `languages` VALUES (9, 'Italian');

INSERT INTO `languages` VALUES (10, 'Romansh');

-- 创建 countries 表
CREATE TABLE `countries` (
    `id` INT NOT NULL,
    `name` TEXT,
    `overall_score` DOUBLE,
    `justice_score` DOUBLE,
    `health_score` DOUBLE,
    `education_score` DOUBLE,
    `economics_score` DOUBLE,
    `politics_score` DOUBLE,
    PRIMARY KEY (`id`)
);

-- 插入 countries 数据
INSERT INTO
    `countries`
VALUES (
        1,
        'Iceland',
        100.0,
        100.0,
        90.5,
        96.7,
        88.0,
        92.8
    );

INSERT INTO
    `countries`
VALUES (
        2,
        'Sweden',
        99.2,
        90.8,
        94.8,
        95.5,
        90.3,
        93.1
    );

INSERT INTO
    `countries`
VALUES (
        3,
        'Canada',
        96.6,
        100.0,
        92.7,
        92.0,
        91.0,
        66.9
    );

INSERT INTO
    `countries`
VALUES (
        4,
        'Denmark',
        95.3,
        86.1,
        94.9,
        97.6,
        88.5,
        78.4
    );

INSERT INTO
    `countries`
VALUES (
        5,
        'Finland',
        92.8,
        80.2,
        91.4,
        91.3,
        86.8,
        100.0
    );

INSERT INTO
    `countries`
VALUES (
        6,
        'Switzerland',
        91.9,
        87.9,
        94.4,
        97.3,
        82.6,
        74.6
    );

INSERT INTO
    `countries`
VALUES (
        7,
        'Norway',
        91.3,
        79.3,
        100.0,
        74.0,
        93.5,
        93.9
    );

INSERT INTO
    `countries`
VALUES (
        8,
        'United States',
        89.8,
        82.9,
        92.8,
        97.3,
        83.9,
        68.6
    );

INSERT INTO
    `countries`
VALUES (
        9,
        'Australia',
        88.2,
        80.7,
        93.3,
        93.9,
        85.3,
        65.1
    );

-- 创建 official_languages 表（关联表）
CREATE TABLE `official_languages` (
    `language_id` INT NOT NULL,
    `country_id` INT NOT NULL,
    PRIMARY KEY (`language_id`, `country_id`),
    FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`),
    FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`)
);

-- 插入 official_languages 数据
INSERT INTO `official_languages` VALUES (1, 1);

INSERT INTO `official_languages` VALUES (2, 2);

INSERT INTO `official_languages` VALUES (3, 3);

INSERT INTO `official_languages` VALUES (4, 4);

INSERT INTO `official_languages` VALUES (5, 5);

INSERT INTO `official_languages` VALUES (6, 6);

INSERT INTO `official_languages` VALUES (7, 6);

INSERT INTO `official_languages` VALUES (9, 6);

INSERT INTO `official_languages` VALUES (10, 6);

INSERT INTO `official_languages` VALUES (8, 7);

INSERT INTO `official_languages` VALUES (3, 8);

INSERT INTO `official_languages` VALUES (3, 9);