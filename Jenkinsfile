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
  //  stage('Database Migrations') {
  //     steps {
  //       sh '''#!/bin/bash
  //       source venv/bin/activate
  //       cd /home/ubuntu/ecommerce_terraform_deployment/backend/
        
  //       # Create the tables in RDS
  //       python manage.py makemigrations account
  //       python manage.py makemigrations payments
  //       python manage.py makemigrations product
  //       python manage.py migrate
        
  //       # Migrate the data from SQLite file to RDS
  //       python manage.py dumpdata --database=sqlite --natural-foreign --natural-primary -e contenttypes -e auth.Permission --indent 4 > datadump.json
  //       python manage.py loaddata datadump.json
  //       '''
  //     }
  //   }
    stage ('Test') {
      steps {
        sh '''#!/bin/bash
        source venv/bin/activate
        cd /home/ubuntu/ecommerce_terraform_deployment/
        pip install pytest-django
        python backend/manage.py makemigrations
        python backend/manage.py migrate
        pytest backend/account/tests.py --verbose --junit-xml test-reports/results.xml
        ''' 
      }
    }
   
//      stage('Init') {
//        steps {
//           dir('Terraform') {
//             sh 'terraform init' 
//             }
//         }
//       } 
     
//       stage('Plan') {
//         steps {
//           withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
//                         string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')]) {
//                             dir('Terraform') {
//                               sh 'terraform plan -out plan.tfplan -var="aws_access_key=${aws_access_key}" -var="aws_secret_key=${aws_secret_key}" -var="rds_db_pw=${rds_db_pw}"' 
//                             }
//           }
//         }     
//       }
//       stage('Apply') {
//         steps {
//             dir('Terraform') {
//                 sh 'terraform apply plan.tfplan' 
//                 }
//         }  
//       }       
//     }
//   }



// cd /home/ubuntu/ecommerce_terraform_deployment/backend/my_project/
//         sed -i "s/ALLOWED_HOSTS = \\[\\]/ALLOWED_HOSTS = ['${PRIVATE_IP}']/" settings.py
//         sed -i "s/# *'ENGINE': 'django.db.backends.postgresql'/'ENGINE': 'django.db.backends.postgresql'/" settings.py
//         sed -i "s/# *'NAME': 'your_db_name'/'NAME': 'postgres_db'/" settings.py
//         sed -i "s/# *'USER': 'your_username'/'USER': 'kurac5user'/" settings.py
//         sed -i "s/# *'HOST': 'your-rds-endpoint.amazonaws.com'/'HOST': 'aws_db_instance.postgres_db.endpoint'/" settings.py
//         # Update the database password using Jenkins Secret
//         withCredentials([string(credentialsId: 'RDS_DB_PASSWORD', variable: 'rds_db_pw')]) {
//             sed -i "s/# *'PASSWORD': 'your_password'/'PASSWORD': '${rds_db_pw}'/" settings.py
//         }
//         cd ecommerce_terraform_deployment/backend/
//         # Start the backend server in the background
//         python manage.py runserver 0.0.0.0:8000 &

//         # Set up the frontend
//         cd /home/ubuntu/ecommerce_terraform_deployment/
//         curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt install -y nodejs
//         cd /home/ubuntu/ecommerce_terraform_deployment/frontend/
//         #private_ip=$(hostname -I | awk '{print $1}')
//         sed -i 's/http:\/\/private_ec2_ip:8000/http:\/\/${PRIVATE_IP}:8000/' package.json
//         npm i
//         export NODE_OPTIONS=--openssl-legacy-provider
//         # Start the frontend server in the background
//         npm start &

//         # Wait to ensure both servers have started
//         sleep 10