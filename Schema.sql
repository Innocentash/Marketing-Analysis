-- ============================================================
-- Growify Digital — Star Schema
-- Fact: dim_date (shared dimension)
-- Dims: dim_campaign, dim_product
-- Facts: fact_campaigns, fact_shopify_sales
-- ============================================================

-- ── Date dimension ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dim_date (
    date_id     DATE PRIMARY KEY,
    day         INT,
    week        INT,
    month       INT,
    month_name  VARCHAR(20),
    quarter     INT,
    year        INT
);

-- Populate dim_date for the full data range (Jan 2026 – Mar 2026)
INSERT INTO dim_date
SELECT
    d::DATE                                       AS date_id,
    EXTRACT(DAY   FROM d)::INT                    AS day,
    EXTRACT(WEEK  FROM d)::INT                    AS week,
    EXTRACT(MONTH FROM d)::INT                    AS month,
    TO_CHAR(d, 'Month')                           AS month_name,
    EXTRACT(QUARTER FROM d)::INT                  AS quarter,
    EXTRACT(YEAR  FROM d)::INT                    AS year
FROM generate_series('2026-01-01'::DATE,
                     '2026-03-31'::DATE,
                     '1 day'::INTERVAL) AS d
ON CONFLICT DO NOTHING;

-- ── Campaign fact table ───────────────────────────────────────────────
DROP TABLE IF EXISTS fact_campaigns;

CREATE TABLE fact_campaigns (
    "brand_name" TEXT,
    "date" DATE,
    "campaign_name" TEXT,
    "status" TEXT,
    "ad_set_name" TEXT,
    "ad_name" TEXT,
    "country" TEXT,
    "region" TEXT,
    "FB Spent Funnel (INR)" NUMERIC,
    "spend_inr" NUMERIC,
    "clicks" INT,
    "impressions" INT,
    "page_likes" INT,
    "landing_page_views" INT,
    "link_clicks" INT,
    "adds_to_cart" INT,
    "checkouts_initiated" INT,
    "Adds of Payment Info" INT,
    "purchases" INT,
    "revenue_inr" NUMERIC,
    "website_contacts" INT,
    "Messaging Conversations Started" INT,
    "Adds to Cart Conversion Value (INR)" NUMERIC,
    "Checkouts Initiated Conversion Value (INR)" NUMERIC,
    "Adds of Payment Info Conversion Value (INR)" NUMERIC,
    "CTR_calculated" NUMERIC,
    "CPM_calculated" NUMERIC,
    "CPC_calculated" NUMERIC,
    "ROI_calculated" NUMERIC,
    "ROAS_calculated" NUMERIC
);
-- ── Shopify sales fact table ──────────────────────────────────────────
DROP TABLE IF EXISTS fact_shopify_sales;

CREATE TABLE fact_shopify_sales (
    id SERIAL PRIMARY KEY,

    brand_name TEXT,
    date DATE,
    currency TEXT,
    sales_channel TEXT,
    transaction_timestamp TIMESTAMP,
    order_created_at TIMESTAMP,
    order_updated_at TIMESTAMP,

    order_id Text,
    order_name TEXT,

    country TEXT,
    region TEXT,

    billing_country TEXT,
    billing_province TEXT,
    billing_city TEXT,

    order_tags TEXT,

    product_id Text,
    product_title TEXT,
    product_tags TEXT,
    product_type TEXT,
    variant_title TEXT,

    gross_sales NUMERIC(14,4),
    net_sales NUMERIC(14,4),
    total_sales NUMERIC(14,4),

    orders INT,
    returns_inr NUMERIC(14,4),
    return_rate NUMERIC(10,4),

    items_sold INT,
    items_returned INT,

    avg_order_value NUMERIC(14,4),

    new_customer_orders INT,
    returning_customer_orders INT,
    avg_items_per_order NUMERIC(10,4),

    discounts_inr NUMERIC(14,4),

    sku TEXT,
    customer_sale_type TEXT,
    customer_id TEXT,

    shipping_country TEXT
);

-- ── Indexes (columns used in WHERE / GROUP BY) ────────────────────────
-- We index date, brand, country, region because Power BI and the AI tool
-- filter on these in almost every query.
CREATE INDEX IF NOT EXISTS idx_camp_date    ON fact_campaigns(date);
CREATE INDEX IF NOT EXISTS idx_camp_brand   ON fact_campaigns(brand_name);
CREATE INDEX IF NOT EXISTS idx_camp_country ON fact_campaigns(country);
CREATE INDEX IF NOT EXISTS idx_camp_region  ON fact_campaigns(region);
CREATE INDEX IF NOT EXISTS idx_camp_status  ON fact_campaigns(status);

CREATE INDEX IF NOT EXISTS idx_shop_date    ON fact_shopify_sales(date);
CREATE INDEX IF NOT EXISTS idx_shop_brand   ON fact_shopify_sales(brand_name);
CREATE INDEX IF NOT EXISTS idx_shop_country ON fact_shopify_sales(country);
CREATE INDEX IF NOT EXISTS idx_shop_channel ON fact_shopify_sales(sales_channel);


COPY fact_shopify_sales(
    brand_name,
    date,
    currency,
    sales_channel,
    transaction_timestamp,
    order_created_at,
    order_updated_at,
    order_id,
    order_name,
    country,
    region,
    billing_country,
    billing_province,
    billing_city,
    order_tags,
    product_id,
    product_title,
    product_tags,
    product_type,
    variant_title,
    gross_sales,
    net_sales,
    total_sales,
    orders,
    returns_inr,
    return_rate,
    items_sold,
    items_returned,
    avg_order_value,
    new_customer_orders,
    returning_customer_orders,
    avg_items_per_order,
    discounts_inr,
    sku,
    customer_sale_type,
    customer_id,
    shipping_country
)
FROM 'D:/assesment project/cleaned_Shopify_Sales.csv'
DELIMITER ','
CSV HEADER
ENCODING 'LATIN1';


select * from Dim_date;



SELECT 
    f.date,
    f.country,
    f.sales_channel,
    SUM(f.total_sales) AS total_sales,
    SUM(f.orders) AS total_orders,
    SUM(f.items_sold) AS items_sold
FROM fact_shopify_sales f
GROUP BY f.date, f.country, f.sales_channel
ORDER BY f.date;



SELECT 
    campaign_name,
    SUM(spend_inr) AS total_spend,
    SUM(revenue_inr) AS total_revenue,
    AVG("CPC_calculated") AS avg_cpc,
    AVG("CTR_calculated") AS avg_ctr,
    AVG("ROAS_calculated") AS avg_roas
FROM fact_campaigns
WHERE date BETWEEN '2026-01-01' AND '2026-03-31'
GROUP BY campaign_name
ORDER BY total_revenue DESC;
