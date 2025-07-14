pipeline {
    agent any

    environment {
        IMAGE_NAME = 'valenmataloni/valentina-mysql'
        IMAGE_TAG = '1.0'
        CONTAINER_NAME = 'mysql-valentina'
        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'
    }

    stages {
        stage('Verificar archivos') {
            steps {
                sh 'ls -la'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }

        stage('Remove previous container (if exists)') {
            steps {
                sh """
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true
                """
            }
        }

        stage('Run Container') {
            steps {
                sh """
                docker run -d --name $CONTAINER_NAME -p 3306:3306 \
                    -e MYSQL_ROOT_PASSWORD=root123 \
                    $IMAGE_NAME:$IMAGE_TAG
                """
            }
        }

        stage('Test Container') {
            steps {
                sh """
                echo "Esperando que MySQL arranque dentro del contenedor..."
                for i in {1..30}; do
                    docker exec $CONTAINER_NAME mysqladmin ping -uroot -proot123 --silent && break
                    echo "Intento \$i: MySQL aún no está listo, esperando..."
                    sleep 2
                done

                echo "Ejecutando consulta de prueba..."
                docker exec $CONTAINER_NAME mysql -uroot -proot123 -e "SHOW DATABASES;" | grep ejemplo
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh "docker push $IMAGE_NAME:$IMAGE_TAG"
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh "docker stop $CONTAINER_NAME || true"
            sh "docker rm $CONTAINER_NAME || true"
        }
    }
}
