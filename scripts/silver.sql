-- Supprimer la table si elle existe déjà
DROP TABLE IF EXISTS silver.customers;
 
-- Créer la table
CREATE TABLE silver.customers (
    customer_id int,
    name VARCHAR(200),
    email VARCHAR(200),
    gender VARCHAR(200),
    signup_date date,
    country VARCHAR(200)
);
 
DROP TABLE IF EXISTS silver.product;
 
create table silver.product(
product_id int,
product_name VARCHAR(200),
categorie VARCHAR(200),
price float,
stock_quantity int,
brand VARCHAR(200)
);
 
DROP TABLE IF EXISTS silver.orders;
 
create table silver.orders(
orders_id int,
customer_id int,
order_date date,
total_amount float,
payment_method varchar(200),
shipping_country VARCHAR(200)
);
 
DROP TABLE IF EXISTS silver.order_items;
 
create table silver.order_items(
order_item_id int,
order_id int,
product_id int,
quantity int,
unit_price float
);
 
DROP TABLE IF EXISTS silver.product_reviews;
 
create table silver.product_reviews(
review_id int,
product_id int,
customer_id int,
rating int,
review_text text,
review_date date
);

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
BEGIN

    RAISE NOTICE '==============================';
    RAISE NOTICE 'Inserting data into silver layer';
    RAISE NOTICE '==============================';

    -- Customers
    TRUNCATE TABLE silver.customers;
    INSERT INTO silver.customers (
        customer_id,
        name,
        email,
        gender,
        signup_date,
        country
    )
    SELECT 
        customer_id,
        name,
        TRIM(email) AS email,
        TRIM(gender) AS gender,
        signup_date,
        TRIM(country) AS country
    FROM bronze.customers;

    -- Product
    TRUNCATE TABLE silver.product;
    INSERT INTO silver.product (
        product_id,
        product_name,
        categorie,
        brand,
        price,
        stock_quantity
    )
    SELECT 
        product_id,
        product_name,
        categorie,
        brand,
        price,
        stock_quantity
    FROM bronze.product;

    -- Orders
    TRUNCATE TABLE silver.orders;
    INSERT INTO silver.orders (
        orders_id,
        customer_id,
        order_date,
        total_amount,
        payment_method,
        shipping_country
    )
    SELECT
        orders_id,
        customer_id,
        order_date,
        total_amount,
        TRIM(payment_method) AS payment_method,
        TRIM(shipping_country) AS shipping_country
    FROM bronze.orders;

    -- Order items
    TRUNCATE TABLE silver.order_items;
    INSERT INTO silver.order_items (
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price
    )
    SELECT 
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price
    FROM bronze.order_items;

    -- Product reviews
    TRUNCATE TABLE silver.product_reviews;
    INSERT INTO silver.product_reviews (
        review_id,
        product_id,
        customer_id,
        rating,
        review_text,
        review_date
    )
    SELECT 
        review_id,
        product_id,
        customer_id,
        rating,
        review_text,
        review_date
    FROM bronze.product_reviews;

    RAISE NOTICE 'Data inserted successfully!';

END;
$$;
