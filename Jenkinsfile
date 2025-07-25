pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'itzikgalanti'
        DOCKERHUB_IMAGE = 'deployment-demo'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token',
                    url: 'https://github.com/IZ1KG/Dev-deployment.git'
            }
        }

        stage('Run Unit Tests') {
            steps {
                script {
                    // במקרה שהקבצים שלך בתיקייה פנימית:
                    dir('.') {
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKERHUB_USER}/${DOCKERHUB_IMAGE}:latest ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_USER}/${DOCKERHUB_IMAGE}:latest
                    '''
                }
            }
        }

        stage('Redeploy Container') {
            steps {
                script {
                    sh '''
                        docker rm -f deployment-demo || true
                        docker pull ${DOCKERHUB_USER}/${DOCKERHUB_IMAGE}:latest
                        docker run -d -p 80:8080 --name deployment-demo ${DOCKERHUB_USER}/${DOCKERHUB_IMAGE}:latest
                    '''
                }
            }
        }
    }
}
