# Ecommerce Terraform Deployment

## Purpose
The purpose of this repository is to provide a comprehensive setup for deploying an eCommerce application using Terraform and managing the application infrastructure with CI/CD pipelines. This setup includes both backend (Django) and frontend (Node.js) services, along with Jenkins for automation, and ensures seamless communication between components while maintaining security through the use of private IP addresses.

## Steps Taken

1. **Clone the Repository**: 
   ```bash
   git clone https://github.com/joesghub/ecommerce_terraform_deployment.git
   ```
   Cloning the repository allows us to have the complete source code and infrastructure configuration available locally.

2. **Set Up Python Environment**:
   ```bash
   cd ecommerce_terraform_deployment
   sudo add-apt-repository -y ppa:deadsnakes/ppa
   sudo apt update -y && sudo apt install -y python3.9 python3.9-venv python3-dev python3-pip
   python3.9 -m venv venv && source venv/bin/activate
   ```
   This step installs Python 3.9 and sets up a virtual environment, ensuring that dependencies are managed effectively without conflicts.

3. **Install Backend Dependencies**:
   ```bash
   cd backend/my_project/
   pip install -r requirements.txt
   ```
   Installing dependencies specified in `requirements.txt` ensures that the backend can run correctly with all necessary libraries.

4. **Configure Django Settings**:
   Modify `settings.py` to include the backend EC2's private IP address in `ALLOWED_HOSTS`. This is crucial for allowing requests from specified sources to ensure security.
   ```bash
   nano settings.py
   ```

5. **Launch Django Server**:
   ```bash
   cd ../
   python manage.py runserver 0.0.0.0:8000
   ```
   Running the Django server allows us to access the backend services locally or remotely.

6. **Set Up Node.js for the Frontend**:
   ```bash
   curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt install -y nodejs
   npm i
   ```
   Installing Node.js and the necessary packages ensures that the frontend can function and interact with the backend effectively.

7. **Configure Jenkins and Terraform**:
   - Create EC2 instance for Jenkins.
   - Install Git, Terraform, and necessary extensions.
   - Configure security groups to allow required traffic.
   ```bash
   sudo apt update -y && sudo apt install -y git
   cd ecommerce_terraform_deployment/Terraform
   ```

## System Design Diagram
A diagram illustrating the architecture of the deployment can be found in the repository. Please ensure that `Diagram.jpg` is placed in the root directory of the repository.


## Issues / Troubleshooting

1. **Invalid for_each Argument in Target Group Attachment**
   - **Error**: 
     ```
     Invalid for_each argument
     The "for_each" set includes values derived from resource attributes that cannot be determined until apply.
     ```
   - **Description**: Attempting to use instance IDs in the `for_each` argument that are only known after the apply phase. Terraform cannot determine the full set of keys needed for the resources.
   - **Solution**: 
     - Use a static map instead of a dynamic set for `for_each`:
       ```hcl
       resource "aws_lb_target_group_attachment" "tg_attachments" {
         for_each = {
           "ec2_front_1a" => aws_instance.ec2_front_1a.id,
           "ec2_front_1b" => aws_instance.ec2_front_1b.id,
         }
         target_group_arn = aws_lb_target_group.tg.arn
         target_id        = each.value
         port             = 80
       }
       ```

2. **Load Balancer Deletion Error**
   - **Error**: 
     ```
     OperationNotPermitted: Load balancer cannot be deleted because deletion protection is enabled.
     ```
   - **Description**: The Elastic Load Balancer (ELB) cannot be deleted due to deletion protection being enabled.
   - **Solution**: Disable deletion protection on the ELB before attempting to delete it.

3. **SSH and Permissions Issues**
   - **Description**: Encountered permission issues while accessing directories as the Jenkins user.
   - **Solution**: Set permissions on the `/home/ubuntu` directory to allow access by the Jenkins user:
     ```bash
     sudo chown -R ubuntu:ubuntu /home/ubuntu
     sudo chmod 755 /home/ubuntu
     sudo chown -R jenkins:jenkins /home/ubuntu/ecommerce_terraform_deployment/
     ```

4. **Terraform Logging Configuration**
   - **Description**: Need to capture detailed logs for Terraform operations.
   - **Solution**: Use the following environment variables to specify log level and log file path:
     ```bash
     export TF_LOG=DEBUG
     export TF_LOG_PATH=/home/ubuntu/logs/terraform_debug.log
     terraform apply -auto-approve
     ```

5. **Dynamic Dependencies Management**
   - **Description**: Issues with managing dependencies dynamically in Terraform configurations.
   - **Solution**: Utilize Terraform outputs to reference instance IDs dynamically:
     ```hcl
     output "ec2_instance_ids" {
       value = [aws_instance.ec2_front_1a.id, aws_instance.ec2_front_1b.id]
     }
     ```



## Optimization
- **Environment Variables**: Further optimization can be achieved by leveraging environment variables in Jenkins to dynamically configure the backend private IP in both Django and Node.js applications, reducing hardcoding in `settings.py` and `package.json`.
  
- **Automated Tests**: Implementing automated testing for both backend and frontend services would ensure the integrity of the application during deployment cycles.

- **Improved Resource Management**: Consider utilizing Terraform modules for better organization and reusability of configurations, enhancing maintainability.

## Conclusion
This repository provides a robust framework for deploying an eCommerce application with secure backend communication and efficient management through CI/CD pipelines. Continuous improvements and optimizations are encouraged to enhance the performance and reliability of the deployed infrastructure.

## Additional Information
For more detailed information on the project and its components, please refer to the individual directories within the repository or the official documentation for the respective technologies used.

