pipeline {
    agent any
    
    environment {
        aws_creds = credentials('aws-auth-creds')
    }
    
    parameters {
        booleanParam(name: 'destroyOption', defaultValue: false, description: 'Check this box to destroy infrastructure')
        string(name: 'terraformPlan', description: 'Path to Terraform plan file', defaultValue: "${env.WORKSPACE}/")
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Run Terraform plan and save the output to a file
                    sh "terraform plan -out=${params.terraformPlan}"
                }
            }
        }

        stage('Approval') {
            input {
                message 'Do you want to apply the Terraform changes?'
                ok 'Yes'
            }
            steps {
                // Do nothing here, just proceed if approved
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Run Terraform apply using the saved plan
                    sh "terraform apply -auto-approve ${params.terraformPlan}"
                }
            }
        }

        // stage('Deploy') {
        //     when {
        //         expression { !params.destroyOption }
        //     }
        //     steps {
        //         script {
        //                   sh 'terraform apply -auto-approve'
        //                 }
        //             }
        //     }
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
