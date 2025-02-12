pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-web-app'
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials') // Docker Hub credentials
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
            sh 'docker build -t saiteja562/my-web-app:latest .'
        }
    }
}

stage('Push Docker Image to Docker Hub') {
    steps {
        script {
            docker.withRegistry('https://index.docker.io/v1/', DOCKER_HUB_CREDENTIALS) {
                docker.image('saiteja562/my-web-app').push('latest')
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
