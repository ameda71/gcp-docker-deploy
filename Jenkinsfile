pipeline {
    agent any

    environment {
        GCP_CREDENTIALS = credentials('cherr.json')  // Jenkins credentials for GCP
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials')  // Jenkins credentials for Docker Hub
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
                    sh 'docker build -t $DOCKER_HUB_CREDENTIALS_USR/$DOCKER_HUB_CREDENTIALS_PSW:latest .'
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    sh 'docker login -u $DOCKER_HUB_CREDENTIALS_USR -p $DOCKER_HUB_CREDENTIALS_PSW'
                    sh 'docker push $DOCKER_HUB_CREDENTIALS_USR/$DOCKER_HUB_CREDENTIALS_PSW:latest'
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh """
                        terraform apply -var="project_id=$GCP_PROJECT_ID" -var="docker_image=$DOCKER_HUB_CREDENTIALS_USR/$DOCKER_HUB_CREDENTIALS_PSW:latest" -auto-approve
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    def instance_ip = sh(script: "terraform output instance_ip", returnStdout: true).trim()
                    echo "Deployed application is accessible at http://$instance_ip"
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
