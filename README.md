Powershell: docker login
Crear una imagen oficial de mysql: docker run docker run --name valentina-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:8.0
Crear un archivo init.sql
Crear un dockerfile
Crear una imagen personalizada: docker build -t valentina-mysql:8.0 .
Ejecutar el contenedor:
  docker run -d `
  --name mysql-valentina `
  -p 3306:3306 `
  -v mysql-data:/var/lib/mysql `
  -e MYSQL_ROOT_PASSWORD=root123 `
  valentina-mysql:8.0
Etiquetar la imagen de Docker: docker tag valentina-mysql:8.0 valenmataloni/valentina-mysql:1.0
Iniciar sesion: docker login
Subir la imagen: docker push valenmataloni/valentina-mysql:1.0
Probar que funcione: 
  docker run -d \
  --name mysql-valentina \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=root123 \
  valenmataloni/valentina-mysql:1.0
Comprobar entrando al contenedor: docker exec -it mysql-valentina mysql -u root -p
Password: root123
 mysql> SELECT * FROM usuarios;
+----+---------+
| id | nombre  |
+----+---------+
|  1 | Camila  |
|  2 | Matias  |
|  3 | Daniela |
+----+---------+
3 rows in set (0.00 sec)