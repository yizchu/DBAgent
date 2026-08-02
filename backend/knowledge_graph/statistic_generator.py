# 统计信息生成模块
import pandas as pd
from typing import Dict, List
import numpy as np

class StatisticGenerator:
    def __init__(self, kg):
        self.kg = kg

    def generate_statistics(self, connection, database_name: str):
        """生成数据库的统计信息
        """
        cursor = connection.cursor()

        # 获取数据库中的所有表
        cursor.execute(f"USE {database_name}")
        cursor.execute("SHOW TABLES")
        tables = [table[0] for table in cursor.fetchall()]

        for table_name in tables:
            table_entity_id = f"table:{database_name}.{table_name}"

            # 获取表的所有数据
            cursor.execute(f"SELECT * FROM {table_name}")
            data = cursor.fetchall()

            # 为表创建统计信息实体
            table_stat_entity_id = f"statistic:{database_name}.{table_name}"
            self.kg.add_entity(table_stat_entity_id, 'statistic', f"{table_name}的统计信息")
            self.kg.add_relationship(table_entity_id, table_stat_entity_id, 'has_statistic')

            # 获取表的总行数
            cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
            total_rows = cursor.fetchone()[0]
            self.kg.add_attribute(table_stat_entity_id, 'total_rows', total_rows)

            # 获取表的列信息
            cursor.execute(f"DESCRIBE {table_name}")
            columns = cursor.fetchall()
            column_names = [col[0] for col in columns]

            df = pd.DataFrame(data, columns=column_names)

            for column in columns:
                column_name = column[0]
                column_type = column[1]
                column_entity_id = f"column:{database_name}.{table_name}.{column_name}"

                # 为列创建统计信息实体
                column_stat_entity_id = f"statistic:{database_name}.{table_name}.{column_name}"
                self.kg.add_entity(column_stat_entity_id, 'statistic', f"{table_name}.{column_name}的统计信息")
                self.kg.add_relationship(column_entity_id, column_stat_entity_id, 'has_statistic')

                # 生成通用统计信息
                self._generate_common_stats(df, column_name, column_stat_entity_id)

                # 根据列类型生成特定统计信息
                if any(keyword in column_type.lower() for keyword in ['int', 'float', 'double', 'decimal', 'numeric']):
                    self._generate_numeric_stats(df, column_name, column_stat_entity_id)
                elif any(keyword in column_type.lower() for keyword in ['char', 'varchar', 'text', 'string']):
                    self._generate_string_stats(df, column_name, column_stat_entity_id)

        cursor.close()

    def _generate_common_stats(self, df: pd.DataFrame, column_name: str, column_entity_id: str):
        """生成通用统计信息
        """
        # 缺失值数量
        missing_count = df[column_name].isnull().sum()
        self.kg.add_attribute(column_entity_id, 'missing_count', int(missing_count))

        # 非空值数量
        non_null_count = df[column_name].notnull().sum()
        self.kg.add_attribute(column_entity_id, 'non_null_count', int(non_null_count))

        # 唯一值数量
        unique_count = df[column_name].nunique()
        self.kg.add_attribute(column_entity_id, 'unique_count', int(unique_count))

    def _generate_numeric_stats(self, df: pd.DataFrame, column_name: str, column_entity_id: str):
        """生成数值型列统计信息
        """
        # 转换为数值类型
        df[column_name] = pd.to_numeric(df[column_name], errors='coerce')

        # 最小值
        min_val = df[column_name].min()
        if not pd.isnull(min_val):
            self.kg.add_attribute(column_entity_id, 'min_value', float(min_val))

        # 最大值
        max_val = df[column_name].max()
        if not pd.isnull(max_val):
            self.kg.add_attribute(column_entity_id, 'max_value', float(max_val))

        # 平均值
        mean_val = df[column_name].mean()
        if not pd.isnull(mean_val):
            self.kg.add_attribute(column_entity_id, 'mean_value', float(mean_val))

        # 中位数
        median_val = df[column_name].median()
        if not pd.isnull(median_val):
            self.kg.add_attribute(column_entity_id, 'median_value', float(median_val))

        # 标准差
        std_val = df[column_name].std()
        if not pd.isnull(std_val):
            self.kg.add_attribute(column_entity_id, 'std_value', float(std_val))

        # 异常值检测（使用IQR方法）
        Q1 = df[column_name].quantile(0.25)
        Q3 = df[column_name].quantile(0.75)
        IQR = Q3 - Q1
        outliers = df[(df[column_name] < Q1 - 1.5 * IQR) | (df[column_name] > Q3 + 1.5 * IQR)]
        outlier_count = len(outliers)
        self.kg.add_attribute(column_entity_id, 'outlier_count', int(outlier_count))

    def _generate_string_stats(self, df: pd.DataFrame, column_name: str, column_entity_id: str):
        """生成字符串型列统计信息
        """
        # 转换为字符串类型
        df[column_name] = df[column_name].astype(str)

        # 平均长度
        avg_length = df[column_name].str.len().mean()
        if not pd.isnull(avg_length):
            self.kg.add_attribute(column_entity_id, 'avg_length', float(avg_length))

        # 最大长度
        max_length = df[column_name].str.len().max()
        if not pd.isnull(max_length):
            self.kg.add_attribute(column_entity_id, 'max_length', int(max_length))

        # 最小长度
        min_length = df[column_name].str.len().min()
        if not pd.isnull(min_length):
            self.kg.add_attribute(column_entity_id, 'min_length', int(min_length))

        # 频数统计（取前10个最常见的值）
        freq_count = df[column_name].value_counts().head(10).to_dict()
        self.kg.add_attribute(column_entity_id, 'top_10_frequency', freq_count)