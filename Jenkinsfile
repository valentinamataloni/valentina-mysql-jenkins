pipeline {
    agent any

    environment {
        IMAGE_NAME = 'valentinamataloni/valentina-mysql'
        CONTAINER_NAME = 'mysql-valentina'
        MYSQL_ROOT_PASSWORD = 'root'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Clonando repositorio...'
                git url: 'https://github.com/valentinamataloni/valentina-mysql.git', branch: 'main'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-valentina',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Remove previous container and volumes') {
            steps {
                sh '''
                    docker stop $CONTAINER_NAME || true
                    docker rm $CONTAINER_NAME || true
                    docker volume prune -f
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    docker run -d --name $CONTAINER_NAME -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -p 3306:3306 $IMAGE_NAME
                '''
            }
        }

        stage('Test Container') {
            steps {
                sh '''
                    sleep 15
                    docker exec $CONTAINER_NAME mysql -uroot -p$MYSQL_ROOT_PASSWORD -e "SHOW DATABASES;"
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                    docker push $IMAGE_NAME
                '''
            }
        }
    }

    post {
        always {
            echo 'Limpiando contenedor y volúmenes...'
            sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true
                docker volume prune -f
            '''
        }
    }
}
