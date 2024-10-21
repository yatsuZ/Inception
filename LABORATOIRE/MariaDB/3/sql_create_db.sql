CREATE DATABASE IF NOT EXISTS wordpress;

USE wordpress;

CREATE TABLE IF NOT EXISTS utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO utilisateurs (nom, email) VALUES ('Alice', 'alice@example.com');

