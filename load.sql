CREATE TEMPORARY TABLE temp_address (
    street_line1 varchar,
    street_line2 varchar,
    city varchar,
    province varchar,
    country varchar,
    postal_code varchar
);

\copy temp_address FROM 'datasets/address.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',', QUOTE '"');


-- Insert new records and ignore existing ones based on all fields comparison
INSERT INTO address (
    street_line1,
    street_line2,
    city,
    province,
    country,
    postal_code
)
SELECT
    street_line1,
    street_line2,
    city,
    province,
    country,
    postal_code
FROM temp_address t
WHERE NOT EXISTS (
    SELECT 1 FROM address a
    WHERE a.street_line1 = t.street_line1
    AND COALESCE(a.street_line2, '') = COALESCE(t.street_line2, '')
    AND a.city = t.city
    AND a.province = t.province
    AND a.country = t.country
    AND a.postal_code = t.postal_code
);

DROP TABLE temp_address;

CREATE TEMPORARY TABLE temp_category (
    name varchar,
    description text
);

\copy temp_category FROM 'datasets/category.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',', QUOTE '"');

INSERT INTO category (
    name,
    description
)
SELECT
    name,
    description
FROM temp_category t
ON CONFLICT (name) DO UPDATE
    SET description = EXCLUDED.description
    WHERE category.description IS DISTINCT FROM EXCLUDED.description;


DROP TABLE temp_category;
