pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-valentina')
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Clonando repositorio...'
                git branch: 'main', url: 'https://github.com/valentinamataloni/valentina-mysql.git'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-valentina', usernameVariable: 'valenmataloni', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t valenmataloni/valentina-mysql:1.0 .'
            }
        }

        stage('Remove previous container and volumes') {
            steps {
                sh '''
                    docker stop mysql-valentina || true
                    docker rm mysql-valentina || true
                    docker volume prune -f || true
                '''
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d --name mysql-valentina -e MYSQL_ROOT_PASSWORD=1234 valenmataloni/valentina-mysql:1.0'
            }
        }

        stage('Test Container') {
            steps {
                sh '''
                    sleep 5
                    docker exec mysql-valentina bash -c "until mysqladmin ping -uroot -p1234 --silent; do sleep 2; done"
                    docker exec mysql-valentina mysql -uroot -p1234 -e "SHOW DATABASES;"
                '''
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh 'docker push valenmataloni/valentina-mysql:1.0'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh '''
                docker stop mysql-valentina || true
                docker rm mysql-valentina || true
                docker volume prune -f || true
            '''
        }
    }
}
