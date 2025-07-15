pipeline {
    agent any

    environment {
        IMAGE_NAME = "valentinamataloni/valentina-mysql"
        CONTAINER_NAME = "mysql-valentina"
        MYSQL_ROOT_PASSWORD = "root"
    }

    options {
        skipStagesAfterUnstable()
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Clonando repositorio..."
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
            echo "Esperando a que MySQL esté disponible..."
            for i in {1..30}; do
                if docker exec mysql-valentina mysqladmin --protocol=TCP -uroot -proot ping --silent; then
                    echo "MySQL está listo."
                    docker exec mysql-valentina mysql --protocol=TCP -uroot -proot -e "SHOW DATABASES;"
                    exit 0
                fi
                echo "Esperando..."
                sleep 2
            done
            echo "MySQL no respondió a tiempo."
            exit 1
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
