# 🐋 Imagen Docker Personalizada: MySQL + Base de datos inicial

Este proyecto crea una imagen personalizada basada en `mysql:8.0`, con una base de datos predefinida que se inicializa automáticamente al ejecutar el contenedor.

---

## Pasos para construir, ejecutar y subir la imagen

### 1. Iniciar sesión en DockerHub
# Imagen Docker Personalizada: MySQL + Base de datos inicial

Este proyecto crea una imagen personalizada basada en `mysql:8.0`, con una base de datos predefinida que se inicializa automáticamente al ejecutar el contenedor.

---

## Pasos para construir, ejecutar y subir la imagen

### 1. Iniciar sesión en DockerHub

bash - 
docker login

### 2. Crear el archivo init.sql
CREATE DATABASE IF NOT EXISTS ejemplo;
USE ejemplo;

CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

INSERT INTO usuarios (nombre) VALUES ('Camila'), ('Matias'), ('Daniela');

### 3. Crear el archivo Dockerfile

FROM mysql:8.0

COPY init.sql /docker-entrypoint-initdb.d/

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

### 4. Construir la imagen personalizada
docker build -t valentina-mysql:8.0 .
### 5. Ejecutar el contenedor
bash - 
docker run -d \
  --name mysql-valentina \
  -p 3306:3306 \
  -v mysql-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=root123 \
  valentina-mysql:8.0

### 6. Etiquetar la imagen para DockerHub
docker tag valentina-mysql:8.0 valenmataloni/valentina-mysql:1.0
### 7. Subir la imagen a DockerHub
bash - 
docker push valenmataloni/valentina-mysql:1.0
### 8. Probar la imagen desde cualquier máquina
bash - 
docker run -d \
  --name mysql-valentina \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=root123 \
  valenmataloni/valentina-mysql:1.0
### 9. Acceder al contenedor y verificar los datos
docker exec -it mysql-valentina mysql -u root -p
contraseña: root123
# Una vez dentro de MySQL:
USE ejemplo;
SELECT * FROM usuarios;
# Resultado esperado:
+----+---------+
| id | nombre  |
+----+---------+
|  1 | Camila  |
|  2 | Matias  |
|  3 | Daniela |
+----+---------+





