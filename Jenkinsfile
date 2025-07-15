pipeline {
    agent any

    environment {
        DOCKER_USER = 'valenmataloni'
        DOCKER_PASS = credentials('docker-hub-password-id') // Cambia por el ID real de tus credenciales en Jenkins
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Clonando repositorio...'
                git 'https://github.com/valentinamataloni/valentina-mysql.git'
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-password-id', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
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
                script {
                    // Mostrar volúmenes antes
                    sh 'echo "Volúmenes antes de prune:" && docker volume ls'

                    // Detener y eliminar contenedor anterior si existe
                    sh '''
                        docker stop mysql-valentina || true
                        docker rm mysql-valentina || true
                    '''

                    // Limpiar volúmenes no usados
                    sh 'docker volume prune -f'

                    // Mostrar volúmenes después
                    sh 'echo "Volúmenes después de prune:" && docker volume ls'
                }
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
