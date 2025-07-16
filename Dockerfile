# Usar la imagen oficial de MySQL como base
FROM mysql:8.0

# Copiar el script de inicialización a la ruta especial de MySQL
COPY init.sql /docker-entrypoint-initdb.d/

# Exponer el puerto estándar de MySQL
EXPOSE 3306

# Declarar el volumen para que los datos persistan entre reinicios

