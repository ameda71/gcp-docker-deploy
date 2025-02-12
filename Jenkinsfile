pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-web-app'
        GOOGLE_CRED = credentials("id")
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = "saiteja562/ping"
                    def imageTag = "latest"
                    sh "docker build -t ${imageName}:${imageTag} ."
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    def imageName = "saiteja562/ping"
                    def imageTag = "latest"

                    // Use withCredentials to get the credentials from Jenkins
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        // Docker login using credentials from environment variables
                        sh "docker login -u $DOCKER_USER -p $DOCKER_PASS"
                        
                        // Push the image to Docker Hub
                        sh "docker push ${imageName}:${imageTag}"
                    }
                }
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                script {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    def ip = sh(script: 'terraform output -raw instance_ip', returnStdout: true).trim()
                    echo "Web server is accessible at: http://${ip}"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
