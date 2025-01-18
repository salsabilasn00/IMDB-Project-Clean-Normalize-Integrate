# IMDb Non Commercial Dataset Project 
In this project, I process open-source data from IMDb, which has tens of millions of rows in each table, creating a database with a cleaner schema, after performing data cleaning and normalization.
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
Why do we need to split the files into chunks of a maximum of 1 million rows each? Well, let me tell you — the data is REALLY, REALLY BIG (at least, in my opinion). To load this massive dataset into the SQL Server schema, we first need to figure out the most suitable data type for each column in the tables. Why? Because sometimes, what should ideally be an integer might turn out to be stored as a varchar in the dataset or in short, the data is messy, and we’ll need some trial and error to get the column data types right. Splitting the files and using batch inserts make it easier to identify which columns have incompatible data types.

To split the files, we use the following [Python-script](/split_file.py). Make sure to adjust the input_file and output_dir paths in the script to match your input and output file directories.
## 2. Load Data to SQL Server
The data is loaded using a batch insert process. Here's how it works: I load 1 million rows at a time. If the data types match the schema I’ve set up, I continue with the next batch of rows. But if there's an error (e.g., the data type doesn’t match), I modify the table's column type (usually to nvarchar, since it can handle all kinds of data).

<img src="/assets/old database diagram.png" alt="Diagram 1" width="500">
This is the database diagram before we restructure it. You can use the script to create table and load data [here](/Load_data.sql)
## 3. Clean Data


## 4. Normalize Data


## 5. Design a New Schema


