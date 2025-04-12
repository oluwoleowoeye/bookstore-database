CREATE DATABASE bookstore;
USE bookstore; -- Switches to this database
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50)
);
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    publish_date DATE
);
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
CREATE TABLE order_items (
    order_id INT,
    book_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);
INSERT INTO author (name, country) VALUES -- Add Authors
('J.K. Rowling', 'UK'),
('George R.R. Martin', 'USA'),
('Agatha Christie', 'UK');
INSERT INTO book (title, price, publish_date) VALUES -- Add Books
('Harry Potter', 15.99, '1997-06-26'),
('Game of Thrones', 22.50, '1996-08-01'),
('Murder on the Orient Express', 12.99, '1934-01-01');
INSERT INTO book_author (book_id, author_id) VALUES -- Link Books to Authors
(1, 1), -- Harry Potter → J.K. Rowling
(2, 2), -- Game of Thrones → George R.R. Martin
(3, 3); -- Murder on the Orient Express → Agatha Christie
INSERT INTO customer (name, email) VALUES -- Add Customers
('Alice Smith', 'alice@example.com'),
('Bob Johnson', 'bob@example.com');
INSERT INTO orders (customer_id, total_amount) VALUES  -- Create Orders
(1, 38.49), -- Alice's order
(2, 12.99); -- Bob's order
INSERT INTO order_items (order_id, book_id, quantity, price) VALUES  -- Add Order Items
(1, 1, 1, 15.99), -- Alice bought Harry Potter
(1, 2, 1, 22.50), -- Alice also bought Game of Thrones
(2, 3, 1, 12.99); -- Bob bought Murder on the Orient Express
SELECT b.title, a.name AS author -- List All Books with Authors
FROM book b
JOIN book_author ba ON b.book_id = ba.book_id
JOIN author a ON ba.author_id = a.author_id;
SELECT c.name, o.order_id, o.total_amount -- Find Orders by Customer
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id;
SELECT o.order_id, b.title, oi.quantity, oi.price  -- Get All Books in an Order
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN book b ON oi.book_id = b.book_id
WHERE o.order_id = 1;
CREATE USER 'bookstore_reader'@'localhost' IDENTIFIED BY 'readonly123'; -- Create a Read-Only User
GRANT SELECT ON bookstore.* TO 'bookstore_reader'@'localhost';
CREATE USER 'bookstore_admin'@'localhost' IDENTIFIED BY 'admin123'; -- Create an Admin User
GRANT ALL PRIVILEGES ON bookstore.* TO 'bookstore_admin'@'localhost';