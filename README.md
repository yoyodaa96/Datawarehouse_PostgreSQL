# Datawarehouse_PostgreSQL

 🧠 Projet Data Warehouse & Dashboard Power BI — Analyse des ventes et avis produits
<img width="1313" height="810" alt="image" src="https://github.com/user-attachments/assets/86c09701-d2fe-45bf-b8e5-53c95b1b5b38" />


 
📌 Contexte du projet
L’objectif de ce projet est de concevoir une architecture décisionnelle complète (type Data Warehouse) permettant d’analyser les ventes et les avis clients d’un site e-commerce.
L’ensemble du pipeline a été réalisé en PostgreSQL et visualisé dans Power BI, selon les principes d’un modèle en étoile (Star Schema).

🏗️ Architecture applicative

L’architecture repose sur une structure multi-couches inspirée des bonnes pratiques de la data (type Medallion Architecture) :
<img width="1037" height="548" alt="image" src="https://github.com/user-attachments/assets/9c11b9d0-3c92-43bf-b53e-cb0c9046607e" />

1️⃣ Bronze Layer — Raw Data

Contient les données brutes importées depuis des fichiers .csv.

Tables :

bronze.customers

bronze.products

bronze.orders

bronze.order_items

bronze.product_reviews

Chargement via des commandes COPY PostgreSQL.

Aucune transformation n’est effectuée à ce stade.

2️⃣ Silver Layer — Data Cleaning & Transformation

Normalisation, typage et nettoyage des données (trimming, gestion des NULL, typage cohérent).

Logique métier ajoutée :

Harmonisation des valeurs (genre, pays, statut, etc.)

Suppression des doublons

Calculs de colonnes dérivées (line_total, unit_price, etc.)

Données prêtes pour une intégration analytique.

3️⃣ Gold Layer — Data Modeling

Création des vues analytiques structurées selon un modèle en étoile :

gold.dim_customers → dimension client

gold.dim_product → dimension produit

gold.dim_product_reviews → table d’avis clients

gold.fact_orders → table de faits principale (ventes)

Utilisation de clés de surrogate keys via ROW_NUMBER() pour uniformiser les jointures.
<img width="1536" height="1024" alt="ChatGPT Image Oct 20, 2025, 05_53_07 PM" src="https://github.com/user-attachments/assets/2847a0d3-25cc-497e-884c-ccfe4f1293be" />

📊 Analyses Power BI réalisées

Vue ventes :

Chiffre d’affaires total

Nombre de commandes

Panier moyen

Top 3 produits les plus vendus par catégorie

Évolution du CA par mois/année

Vue avis clients :

Nombre total d’avis

Note moyenne par produit et par catégorie

Taux de satisfaction (produits notés vs vendus)
