pipeline {
  agent any
   stages {
    stage ('Build') {
      steps {
        sh '''#!/bin/bash
        #Setup backend
        cd /home/ubuntu/ecommerce_terraform_deployment/backend/
        python3.9 -m venv venv 
        source venv/bin/activate
        pip install -r /home/ubuntu/ecommerce_terraform_deployment/backend/requirements.txt
        '''
     }
   }
    stage ('Test') {
      steps {
        sh '''#!/bin/bash
        source /home/ubuntu/ecommerce_terraform_deployment/backend/venv/bin/activate
        cd /home/ubuntu/ecommerce_terraform_deployment/
        pip install pytest-django
        python backend/manage.py makemigrations
        python backend/manage.py migrate
        pytest backend/account/tests.py --verbose --junit-xml test-reports/results.xml
        ''' 
      }
    }
   
     stage('Init') {
       steps {
          dir('Terraform') {
            sh 'terraform init' 
            }
        }
      } 
     
      stage('Plan') {
        steps {
          withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                        string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
                            dir('Terraform') {
                              sh 'terraform plan -out plan.tfplan -var="aws_access_key=${aws_access_key}" -var="aws_secret_key=${aws_secret_key}" -var="rds_db_pw=${rds_db_pw}"' 
                            }
          }
        }     
      }
      stage('Apply') {
        steps {
            dir('Terraform') {
                sh 'terraform apply plan.tfplan' 
                }
        }  
      }       
    }
  }



