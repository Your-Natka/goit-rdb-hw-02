CREATE TABLE customers (
customer_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
address VARCHAR(255) NOT NULL
);


CREATE TABLE products (
product_id INT AUTO_INCREMENT PRIMARY KEY,
product_name VARCHAR(100) NOT NULL
);


CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT NOT NULL,
order_date DATE NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);


CREATE TABLE order_items (
order_id INT NOT NULL,
product_id INT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY (order_id, product_id),
FOREIGN KEY (order_id) REFERENCES orders(order_id)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (product_id) REFERENCES products(product_id)
ON DELETE RESTRICT
ON UPDATE CASCADE
);