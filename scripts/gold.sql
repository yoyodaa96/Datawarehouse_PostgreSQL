create or replace view gold.dim_customers as 
select 
ROW_NUMBER() OVER (ORDER BY customer_id) AS customer_key,
customer_id,
TRIM(name) AS customer_name,
TRIM(email) AS email,
gender,
signup_date,
country
from silver.customers

create or replace view gold.dim_product as 
select 
ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,
product_id,
product_name,
categorie, 
price,
stock_quantity,
brand
from silver.product


CREATE OR REPLACE VIEW gold.dim_product_reviews AS
SELECT
    pr.review_id,
    pr.product_id,
    p.product_name,
    pr.customer_id,
    c.name,
    pr.rating,
    pr.review_text,
    pr.review_date
FROM silver.product_reviews pr
LEFT JOIN silver.product p ON pr.product_id = p.product_id
LEFT JOIN silver.customers c ON pr.customer_id = c.customer_id;

drop view if exists gold.fact_orders;

CREATE OR REPLACE VIEW gold.fact_orders AS
SELECT
    -- Clés techniques (foreign keys vers les dimensions)
    c.customer_key,
    p.product_key,

    -- Clés métier et identifiants
    o.orders_id,
    oi.order_item_id,

    -- Détails de la commande
    o.order_date,
    o.total_amount,
    o.payment_method,
    o.shipping_country,

    -- Détails produits
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total,

    -- Lien avec les avis produits (optionnel)
    pr.review_id,
    pr.rating,
    pr.review_date

FROM silver.orders o
-- Relier la commande au client
LEFT JOIN gold.dim_customers c 
    ON o.customer_id = c.customer_id

-- Relier la commande aux articles commandés
LEFT JOIN silver.order_items oi 
    ON o.orders_id = oi.order_id

-- Relier chaque article au produit
LEFT JOIN gold.dim_product p 
    ON oi.product_id = p.product_id

-- Relier les avis (s’il y en a)
LEFT JOIN silver.product_reviews pr 
    ON pr.product_id = p.product_id 
   AND pr.customer_id = c.customer_id;
