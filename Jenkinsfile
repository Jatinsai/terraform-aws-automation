pipeline {
    agent any
    
    environment {
        aws_creds = credentials('aws-auth-creds')
    }
    
    parameters {
        booleanParam(name: 'destroyOption', defaultValue: false, description: 'Check this box to destroy infrastructure')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Jatinsai/terraform-aws-automation.git'            }
        }

        stage('Initialize') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Plan') {
            steps {
                script {
                    sh 'terraform plan'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    if (params.destroyOption) {
                            // Run Terraform destroy
                            sh 'terraform destroy -auto-approve'
                        } else {
                            // Run Terraform apply (or any other deployment logic)
                            sh 'terraform apply -auto-approve'
                        }
                }
            }
        }
    }
}
