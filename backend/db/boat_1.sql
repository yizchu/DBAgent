-- 启用外键约束（确保外键生效）
SET FOREIGN_KEY_CHECKS = 1;

-- 创建 Sailors 表
CREATE TABLE `Sailors` (
    `sid` INT PRIMARY KEY,
    `name` VARCHAR(255),
    `rating` INT,
    `age` INT
);

-- 创建 Boats 表
CREATE TABLE `Boats` (
    `bid` INT PRIMARY KEY,
    `name` VARCHAR(255),
    `color` VARCHAR(255)
);

-- 创建 Reserves 表
CREATE TABLE `Reserves` (
    `sid` INT,
    `bid` INT,
    `day` VARCHAR(255),
    FOREIGN KEY (`sid`) REFERENCES `Sailors` (`sid`),
    FOREIGN KEY (`bid`) REFERENCES `Boats` (`bid`)
);