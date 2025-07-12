CREATE DATABASE IF NOT EXISTS ejemplo;
USE ejemplo;

CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

INSERT INTO usuarios (nombre) VALUES ('Camila'), ('Matias'), ('Daniela');
