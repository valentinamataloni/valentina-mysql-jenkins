pipeline {
    agent any

    environment {
        DOCKER_USER = 'valenmataloni'
        DOCKER_IMAGE = "${DOCKER_USER}/valentina-mysql"
        DOCKER_TAG = '1.0'
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
                withCredentials([usernamePassword(credentialsId: 'dockerhub-valentina', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
                '''
            }
        }

        stage('Remove previous container (if exists)') {
            steps {
                sh '''
                    docker stop mysql-valentina || true
                    docker rm mysql-valentina || true
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    docker run -d --name mysql-valentina -e MYSQL_ROOT_PASSWORD=1234 $DOCKER_IMAGE:$DOCKER_TAG
                '''
            }
        }

        stage('Test Container') {
    steps {
        sh '''
            sleep 10
            docker exec mysql-valentina mysql -uroot -p1234 -h127.0.0.1 -e "SHOW DATABASES;"
        '''
    }
}

        stage('Push to DockerHub') {
            steps {
                sh '''
                    docker push $DOCKER_IMAGE:$DOCKER_TAG
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh '''
                docker stop mysql-valentina || true
                docker rm mysql-valentina || true
            '''
        }
    }
}
