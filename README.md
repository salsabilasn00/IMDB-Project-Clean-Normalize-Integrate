# IMDb Non Commercial Dataset Project 
In this project, I process Non Commercial Dataset from IMDb, which has tens of millions of rows in each table, creating a database with a cleaner schema, after performing data cleaning and normalization.

- data source : 
## Table of Contents
1. [Split Files](#1-split-files):
    Break down large datasets into smaller files with a maximum of 1 million rows per file for better manageability.
2. [Load Data to SQL Server](#2-load-data-to-sql-server): 
    Import the split files into SQL Server using batch insert for efficient data loading.
3. [Clean Data](#3-clean-data): 
    Perform cleaning operations, such as removing unnecessary characters, handling missing values, and standardizing formats.
4. [Normalize Data](#4-normalize-data): 
    Apply normalization techniques to reduce redundancies and improve data structure integrity.
5. [Design a New Schema](#5-design-a-new-schema): 
    Create a new schema by restructuring tables, adding new columns, and aligning the design for optimal usability.

## 1. Split Files
The data is extremely large, so we split each table into files with a maximum of 1 million rows. The data is messy, and we’ll need some trial and error to get the column data types right. Splitting the files and using batch inserts make it easier to identify which columns have incompatible data types.

To split the files, use the following [Python-script](/split_file.py). Make sure to adjust the input_file and output_dir paths in the script to match your input and output file directories.
## 2. Load Data to SQL Server
The data is loaded using a batch insert process. I load 1 million rows at a time. If the data types match the schema I’ve set up, I continue with the next batch of rows. But if there's an error (e.g., the data type doesn’t match), I modify the table's column type (usually to nvarchar, since it can handle all kinds of data).

<img src="/assets/old database diagram.png" alt="Diagram 1" width="600">

This is the database diagram before we restructure it. You can use the script to create table and load data [here](/Load_data.sql)

## 3. Clean Data
I clean the data by replacing the values "/N" with NULL, and then converting the data type of the cleaned columns to their appropriate types.

For the TITLE_AKAS table: For entries where the language is NULL, I want to fill in the value based on other records with the same region. However, since many regions are associated with multiple languages, I will only replace the language for regions that are associated with a single language.


## 4. Normalize Data
I am performing 1NF normalization by addressing multivalued attributes and creating several junction tables. For more details, you can refer to the script [here](/normalization%20and%20new%20schema.sql), which includes both the normalization process and the creation of the new database design.

## 5. New Schema
Here is the final schema after the normalization and cleaning process, without the addition of external data.

<img src="/assets/up diagram.png" alt="Diagram 1" width="900">
<img src="/assets/down diagram.png" alt="Diagram 1" width="900">

 Next, I want to develop this schema by adding new data. As you can see in the TITLE_AKAS table, there are columns for Region and Language, which contain country codes according to the ISO 3166-1 alpha-2 standard and language codes according to the ISO 639-1 standard. I want to create new tables for both Region and Language, with the codes as the primary keys. Additionally, I will add a "Name" column, which will store the full name of the region or language to make the data more comprehensible.