pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-web-app'
        GOOGLE_CRED = credentials("id")  // Make sure "id" is the correct credentials ID in Jenkins
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
                    // Build the Docker image
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
                    // Fetch Google Cloud credentials from Jenkins
                    withCredentials([file(credentialsId: 'id', variable: 'GOOGLE_CRED')]) {
                        // Set up the Google Cloud credentials for Terraform
                        sh 'export GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_CRED'
                        sh 'terraform init'
                        
                        // Run terraform apply with error handling
                        sh ''' 
                            set -e  # Exit immediately if a command exits with a non-zero status
                            terraform apply -auto-approve
                        '''
                    }
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
            cleanWs()  // Clean workspace after pipeline run
        }
    }
}
