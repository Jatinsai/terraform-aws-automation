pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nginx"
        minikube_secret = credentials('minikube-secret')
    }

    stages {
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh '''
                    docker build -t $DOCKER_IMAGE .
                    minikube start
                    minikube profile list
                    minikube status
                    '''
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

        stage('Install kubectl') {
            steps {
                script {
                    sh 'sudo snap install kubectl --classic'
                    sh 'export PATH=$PATH:/usr/bin'
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Apply Kubernetes manifests
                    sh "kubectl create deployment mydeploy --image=$DOCKER_IMAGE --replicas=3"                 
                }
            }
        }
    }
}
