create schema bronze;
create schema silver;
create schema gold;

-- Supprimer la table si elle existe déjà
DROP TABLE IF EXISTS bronze.customers;
 
-- Créer la table
CREATE TABLE bronze.customers (
    customer_id int,
    name VARCHAR(200),
    email VARCHAR(200),
    gender VARCHAR(200),
    signup_date date,
    country VARCHAR(200)
);
 
DROP TABLE IF EXISTS bronze.product;
 
create table bronze.product(
product_id int,
product_name VARCHAR(200),
categorie VARCHAR(200),
price float,
stock_quantity int,
brand VARCHAR(200)
);
 
DROP TABLE IF EXISTS bronze.orders;
 
create table bronze.orders(
orders_id int,
customer_id int,
order_date date,
total_amount float,
payment_method varchar(200),
shipping_country VARCHAR(200)
);
 
DROP TABLE IF EXISTS bronze.order_items;
 
create table bronze.order_items(
order_item_id int,
order_id int,
product_id int,
quantity int,
unit_price float
);
 
DROP TABLE IF EXISTS bronze.product_reviews;
 
create table bronze.product_reviews(
review_id int,
product_id int,
customer_id int,
rating int,
review_text text,
review_date date
);
 
CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
BEGIN

    RAISE NOTICE '==============================';
    RAISE NOTICE 'Loading bronze layer';
    RAISE NOTICE '==============================';

    TRUNCATE TABLE bronze.customers;

    COPY bronze.customers
    FROM 'C:\\Program Files (x86)\\PostgreSQL\\dataset_product\\customers.csv'
    DELIMITER ','
    CSV HEADER;

    TRUNCATE TABLE bronze.product;

    COPY bronze.product
    FROM 'C:\\Program Files (x86)\\PostgreSQL\\dataset_product\\products.csv'
    DELIMITER ','
    CSV HEADER;

    TRUNCATE TABLE bronze.orders;

    COPY bronze.orders
    FROM 'C:\\Program Files (x86)\\PostgreSQL\\dataset_product\\orders.csv'
    DELIMITER ','
    CSV HEADER;

    TRUNCATE TABLE bronze.order_items;

    COPY bronze.order_items
    FROM 'C:\\Program Files (x86)\\PostgreSQL\\dataset_product\\order_items.csv'
    DELIMITER ','
    CSV HEADER;

    TRUNCATE TABLE bronze.product_reviews;

    COPY bronze.product_reviews
    FROM 'C:\\Program Files (x86)\\PostgreSQL\\dataset_product\\product_reviews.csv'
    DELIMITER ','
    CSV HEADER;

    RAISE NOTICE 'Bronze layer loaded successfully!';

END;
$$;
call bronze.load_bronze();
