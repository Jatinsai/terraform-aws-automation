pipeline {
    agent any

    parameters {
        string(name: 'DOCKER_IMAGE', defaultValue: '', description: 'Docker image name and tag')
        string(name: 'DEPLOYMENT_NAME', defaultValue: '', description: 'Kubernetes deployment name')
    }
    environment {
        DOCKER_IMAGE = "${params.DOCKER_IMAGE}"
        MINIKUBE_PROFILE = 'minikube'
        minikube_secret = credentials('minikube-secret')
    }

    stages {        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh '''
                    docker build -t ${DOCKER_IMAGE} .                    
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
                    sh "minikube image load ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Install kubectl') {
            steps {
                script {
                    def kubectlStatus = sh(script: 'kubectl version', returnStatus: true)

                    if (kubectlStatus != 0) {
                        echo 'kubectl is not installed. Installing kubectl...'
                        // Install kubectl
                        sh 'sudo apt-get update && sudo snap install kubectl --classic'
                        sh 'export PATH=$PATH:/usr/bin'
                    } else {
                        echo 'kubectl is already installed.'
                    }                   
                }
            }
        }

        stage('Deploy to Minikube') {
            steps {
                script {
                    // Get the deployment name from parameters
                    def deploymentName = params.DEPLOYMENT_NAME

                    // Check if the deployment exists
                    def deploymentExists = sh(script: "kubectl get deployment $deploymentName --no-headers --output=name", returnStatus: true)

                    if (deploymentExists == 0) {
                        // Ask for user confirmation
                        def userConfirmation = input(
                            id: 'confirmDelete',
                            message: "Deployment $deploymentName exists. Do you want to delete it?",
                            parameters: [booleanParam(defaultValue: false, description: 'Confirm deletion', name: 'CONFIRM_DELETE')]
                        )
                        // Check if the user approved and retrieve the parameters
                        if (userConfirmation) {
                            def confirmDelete = userConfirmation['params']['CONFIRM_DELETE']

                            if (confirmDelete) {
                                // Delete the deployment
                                sh "kubectl delete deployment $deploymentName"
                            } else {
                                echo 'User chose not to delete the deployment. Exiting...'
                            }                        
                        } else {
                            echo "Deployment $deploymentName does not exist."
                            sh "kubectl create deployment $deploymentName --image=$DOCKER_IMAGE --replicas=3"                                     
                    }
                }
            }
        }
    }
  }
}
