-- 启用外键约束（MySQL 等效写法）
SET FOREIGN_KEY_CHECKS = 1;

-- 创建 customers 表
CREATE TABLE `customers` (
    `Id` INT PRIMARY KEY,
    `LastName` VARCHAR(255),
    `FirstName` VARCHAR(255)
);

-- 创建 goods 表（Price 用 DECIMAL 保证金额精度）
CREATE TABLE `goods` (
    `Id` VARCHAR(255) PRIMARY KEY,
    `Flavor` VARCHAR(255),
    `Food` VARCHAR(255),
    `Price` DECIMAL(5, 2)
);

-- 创建 receipts 表
CREATE TABLE `receipts` (
    `ReceiptNumber` INT PRIMARY KEY,
    `Date` VARCHAR(255), -- 保留原日期文本格式，如需转换可后续用 STR_TO_DATE
    `CustomerId` INT,
    FOREIGN KEY (`CustomerId`) REFERENCES `customers` (`Id`)
);

-- 创建 items 表（修正外键语法，确保依赖表已创建）
CREATE TABLE `items` (
    `Receipt` INT,
    `Ordinal` INT,
    `Item` VARCHAR(255),
    PRIMARY KEY (`Receipt`, `Ordinal`),
    FOREIGN KEY (`Item`) REFERENCES `goods` (`Id`),
    FOREIGN KEY (`Receipt`) REFERENCES `receipts` (`ReceiptNumber`)
);