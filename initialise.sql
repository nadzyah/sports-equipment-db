CREATE TYPE equipment_status_enum AS ENUM ('produced', 'discontinued', 'coming_soon');
CREATE TYPE customer_status_enum AS ENUM ('active', 'inactive', 'blacklisted');
CREATE TYPE order_status_enum AS ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled');
CREATE TYPE order_item_status_enum AS ENUM ('pending', 'shipped', 'delivered', 'returned');
CREATE TYPE warehouse_status_enum AS ENUM ('active', 'inactive', 'maintenance');

CREATE TABLE CATEGORY (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
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
    name VARCHAR(255) NOT NULL,
    address_id INT NOT NULL REFERENCES ADDRESS(id),
    status warehouse_status_enum NOT NULL DEFAULT 'active'
);

CREATE TABLE STOCK (
    id SERIAL PRIMARY KEY,
    warehouse_id INT NOT NULL REFERENCES WAREHOUSE(id),
    quantity INT NOT NULL,
    minimum_order_quantity INT NOT NULL DEFAULT 1,
    last_restock_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE EQUIPMENT (
    id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES CATEGORY(id),
    stock_id INT NOT NULL REFERENCES STOCK(id),
    model VARCHAR(255) NOT NULL,
    brand VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    status equipment_status_enum NOT NULL DEFAULT 'produced'
);

CREATE TABLE CUSTOMER (
    id SERIAL PRIMARY KEY,
    address_id INT NOT NULL REFERENCES ADDRESS(id),
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(9) UNIQUE NOT NULL,
    status customer_status_enum NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "order" (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES CUSTOMER(id),
    status order_status_enum NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ORDERITEM (
    order_id INT NOT NULL REFERENCES "order"(id),
    equipment_id INT NOT NULL REFERENCES EQUIPMENT(id),
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    status order_item_status_enum NOT NULL,
    PRIMARY KEY (order_id, equipment_id)
);
