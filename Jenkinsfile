pipeline {
    agent any

    parameters {
        string(name: 'DOCKER_IMAGE', defaultValue: '', description: 'Docker image name and tag')
        //string(name: 'DEPLOYMENT_NAME', defaultValue: '', description: 'Kubernetes deployment name')
        choice(name: 'DEPLOYMENT_NAME', choices: getKubernetesDeployments(), description: 'Select a Kubernetes deployment')
        booleanParam(name: 'destroyOption', defaultValue: false, description: 'Check this box to destroy deployment')
    }
    environment {
        DOCKER_IMAGE = "${params.DOCKER_IMAGE}"
        MINIKUBE_PROFILE = 'minikube'
        minikube_secret = credentials('minikube-secret')
        deploymentName = "${params.DEPLOYMENT_NAME}"
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
            when {
                expression { !params.destroyOption }
            }
            steps {
                script {                    
                    def deploymentName = params.DEPLOYMENT_NAME                    
                    def deploymentExists = sh(script: "kubectl get deployment $deploymentName --no-headers --output=name", returnStatus: true)
                    if (deploymentExists == 0) {
                        echo "$deploymentName exists already.."
                        } else {
                            echo "Deployment $deploymentName does not exist."
                            sh "kubectl create deployment $deploymentName --image=$DOCKER_IMAGE --replicas=3"                                     
                        }
                    }
                }
            }
        stage('Deleting Deployment') {
            when {
                expression { params.destroyOption }
            }
            steps {
                script {
                        def deploymentName = params.DEPLOYMENT_NAME                    
                        def deploymentExists = sh(script: "kubectl get deployment $deploymentName --no-headers --output=name", returnStatus: true)
                        if (deploymentExists == 0) {
                            echo "$deploymentName exists!"                               
                              sh 'kubectl delete deployment ${deploymentName}'
                        }else{
                            echo "$deploymentName not exists!" 
                        }
                }
            }
        }
    }
}

def getKubernetesDeployments() {
    def deployments = sh(script: "kubectl get deployments --no-headers -o custom-columns=':metadata.name' -n ${params.K8S_NAMESPACE}", returnStdout: true).trim().split('\n')
    return deployments
}
