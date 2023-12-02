pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "docker pull nginx"
    }

    stages {
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t $DOCKER_IMAGE ."
                }
            }
        }

        stage('Push Docker Image to Minikube Registry') {
            steps {
                script {
                    // Load Docker image into Minikube's internal registry
                    sh "minikube image load $DOCKER_IMAGE"
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Apply Kubernetes manifests
                    sh "kubectl apply -f kubernetes/nginx-deployment.yaml"
                    sh "kubectl apply -f kubernetes/nginx-service.yaml"
                }
            }
        }
    }
}
