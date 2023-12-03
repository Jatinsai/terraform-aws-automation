pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "nginx"
        MINIKUBE_PROFILE = 'minikube'
        minikube_secret = credentials('minikube-secret')
    }

    stages {        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh '''
                    docker build -t $DOCKER_IMAGE .                    
                    '''
                }
            }
        }
        stage('Check and Start Minikube') {
            steps {
                script {
                    // Check if Minikube is already running
                    def minikubeStatus = sh(script: "minikube status -p $MINIKUBE_PROFILE", returnStatus: true)

                    if (minikubeStatus != 0) {
                        echo 'Minikube is not running. Starting Minikube...'
                        // Start Minikube
                        sh "minikube start -p $MINIKUBE_PROFILE"
                    } else {
                        echo 'Minikube is already running.'
                        sh "minikube profile list"
                    }
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
