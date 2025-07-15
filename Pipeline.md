# Documentación del Pipeline Jenkins (valentina-mysql)


## Estructura del pipeline

El pipeline está definido en el archivo `Jenkinsfile` y realiza las siguientes etapas:

1. **Clonar el repositorio** desde GitHub.
2. **Login a DockerHub** usando credenciales almacenadas en Jenkins.
3. **Build de la imagen de Docker** utilizando el `Dockerfile` del repositorio.
4. **Eliminar los contenedores/volúmenes previos** para evitar conflictos.
5. **Ejecutar la imagen como contenedor**.
6. **Verificar el estado del contenedor y de MySQL**.
7. **Push de la imagen a DockerHub** si las pruebas son exitosas.


### Jenkins Plugins necesarios

- Docker Pipeline
- Git plugin
- Pipeline

### Herramientas instaladas
- Docker
- Git

### Requisitos de sistema
- Jenkins corriendo sobre máquina provisionada con Vagrant

### Variables y credenciales
Crear las siguientes credenciales en Jenkins:

- **DOCKER_PASS** (tipo: `Secret text`): contraseña de DockerHub.

### Variables del pipeline

- `IMAGE_NAME`: nombre de la imagen (ej: `valenmataloni/valentina-mysql`)
- `TAG`: versión/tag de la imagen

## Replicar el pipeline en una nueva instancia

1. Instalar Jenkins.
2. Instalar los plugins listados anteriormente.
3. Instalar Docker y Git en el sistema operativo.
4. Crear credenciales de tipo `Secret text` en Jenkins con ID: `DOCKER_PASS`.
5. Crear un nuevo `Pipeline job` y asociar el repositorio Git: `https://github.com/valentinamataloni/valentina-mysql.git`
6. Ejecutar el pipeline.
