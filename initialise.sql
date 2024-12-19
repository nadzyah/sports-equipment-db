CREATE TYPE equipment_status_enum AS ENUM ('produced', 'discontinued', 'coming_soon');
CREATE TYPE customer_status_enum AS ENUM ('active', 'inactive', 'blacklisted');
CREATE TYPE order_status_enum AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled');
CREATE TYPE order_item_status_enum AS ENUM ('pending', 'shipped', 'delivered', 'returned');
CREATE TYPE warehouse_status_enum AS ENUM ('active', 'inactive', 'maintenance');

CREATE TABLE CATEGORY (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE ADDRESS (
    id SERIAL PRIMARY KEY,
    street_line1 VARCHAR(255) NOT NULL,
    street_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL
);

CREATE TABLE WAREHOUSE (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    address_id INT NOT NULL REFERENCES ADDRESS(id) ON DELETE CASCADE,
    status warehouse_status_enum NOT NULL DEFAULT 'active'
);

CREATE TABLE EQUIPMENT (
    id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES CATEGORY(id) ON DELETE CASCADE,
    model VARCHAR(255) NOT NULL,
    brand VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    status equipment_status_enum NOT NULL DEFAULT 'produced',
    UNIQUE (brand, model)
);

CREATE TABLE STOCK (
    id SERIAL PRIMARY KEY,
    warehouse_id INT NOT NULL REFERENCES WAREHOUSE(id) ON DELETE CASCADE,
    equipment_id INT NOT NULL REFERENCES EQUIPMENT(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity >= 0),
    minimum_order_quantity INT NOT NULL DEFAULT 1 CHECK (minimum_order_quantity > 0),
    last_restock_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE CUSTOMER (
    id SERIAL PRIMARY KEY,
    address_id INT REFERENCES ADDRESS(id) ON DELETE SET NULL,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    status customer_status_enum NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "order" (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES CUSTOMER(id) ON DELETE CASCADE,
    status order_status_enum NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ORDERITEM (
    order_id INT NOT NULL REFERENCES "order"(id) ON DELETE CASCADE,
    equipment_id INT NOT NULL REFERENCES EQUIPMENT(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    subtotal DECIMAL(10, 2) NOT NULL CHECK (subtotal >= 0),
    status order_item_status_enum NOT NULL,
    PRIMARY KEY (order_id, equipment_id)
);

-- Trigger function for updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at_stock
BEFORE UPDATE ON STOCK
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_customer
BEFORE UPDATE ON CUSTOMER
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER set_updated_at_order
BEFORE UPDATE ON "order"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();
