pipeline {
    agent any
    
    environment {
        aws_creds = credentials('aws-auth-creds')
    }
    
    parameters {
        booleanParam(name: 'destroyOption', defaultValue: false, description: 'Check this box to destroy infrastructure')
    }

    stages {
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
            when {
                expression { !params.destroyOption }
            }
            steps {
                script {
                          sh 'terraform apply -auto-approve'
                        }
                    }
            }
        stage('Destroy') {
            when {
                expression { params.destroyOption }
            }
            steps {
                script {
                          sh 'terraform destroy -auto-approve'
                    }
            }
        }
    }
}
