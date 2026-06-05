-- Northwind SQLite Schema

CREATE TABLE IF NOT EXISTS regions (
    region_id INTEGER PRIMARY KEY AUTOINCREMENT,
    region_description VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS territories (
    territory_id VARCHAR(20) PRIMARY KEY,
    territory_description VARCHAR(50) NOT NULL,
    region_id INTEGER,
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE IF NOT EXISTS categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name VARCHAR(15) NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24),
    fax VARCHAR(24),
    home_page TEXT
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(5) PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24),
    fax VARCHAR(24)
);

CREATE TABLE IF NOT EXISTS customer_demographics (
    customer_type_id VARCHAR(10) PRIMARY KEY,
    customer_desc TEXT
);

CREATE TABLE IF NOT EXISTS customer_customer_demo (
    customer_id VARCHAR(5),
    customer_type_id VARCHAR(10),
    PRIMARY KEY (customer_id, customer_type_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (customer_type_id) REFERENCES customer_demographics(customer_type_id)
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id INTEGER PRIMARY KEY AUTOINCREMENT,
    last_name VARCHAR(20) NOT NULL,
    first_name VARCHAR(10) NOT NULL,
    title VARCHAR(30),
    title_of_courtesy VARCHAR(25),
    birth_date DATE,
    hire_date DATE,
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    home_phone VARCHAR(24),
    extension VARCHAR(4),
    notes TEXT,
    reports_to INTEGER,
    photo_path VARCHAR(255),
    FOREIGN KEY (reports_to) REFERENCES employees(employee_id)
);

CREATE TABLE IF NOT EXISTS employee_territories (
    employee_id INTEGER,
    territory_id VARCHAR(20),
    PRIMARY KEY (employee_id, territory_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (territory_id) REFERENCES territories(territory_id)
);

CREATE TABLE IF NOT EXISTS shippers (
    shipper_id INTEGER PRIMARY KEY AUTOINCREMENT,
    company_name VARCHAR(40) NOT NULL,
    phone VARCHAR(24)
);

CREATE TABLE IF NOT EXISTS products (
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_name VARCHAR(40) NOT NULL,
    supplier_id INTEGER,
    category_id INTEGER,
    quantity_per_unit VARCHAR(20),
    unit_price REAL DEFAULT 0,
    units_in_stock INTEGER DEFAULT 0,
    units_on_order INTEGER DEFAULT 0,
    reorder_level INTEGER DEFAULT 0,
    discontinued INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id VARCHAR(5),
    employee_id INTEGER,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    ship_via INTEGER,
    freight REAL DEFAULT 0,
    ship_name VARCHAR(40),
    ship_address VARCHAR(60),
    ship_city VARCHAR(15),
    ship_region VARCHAR(15),
    ship_postal_code VARCHAR(10),
    ship_country VARCHAR(15),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (ship_via) REFERENCES shippers(shipper_id)
);

CREATE TABLE IF NOT EXISTS order_details (
    order_id INTEGER,
    product_id INTEGER,
    unit_price REAL NOT NULL DEFAULT 0,
    quantity INTEGER NOT NULL DEFAULT 1,
    discount REAL NOT NULL DEFAULT 0,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
