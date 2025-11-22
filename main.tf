# 1. Define the Provider
# This tells Terraform we are working with AWS.
provider "aws" {
  region = "us-east-1"  # We'll build in the Northern Virginia region
}

# 2. Define the Security Group
# This is our "Virtual Firewall". We need to let traffic in.
resource "aws_security_group" "web_sg" {
  name        = "flask-app-sg"
  description = "Allow SSH and Port 5000"

  # Allow incoming traffic on port 5000 (where our Flask app runs)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world
  }

  # Allow incoming SSH (so we can log in if needed)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic (so the server can download updates)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Define the Server (EC2 Instance)
resource "aws_instance" "app_server" {
  # This is the ID for a standard Ubuntu 22.04 server in us-east-1
  ami           = "ami-0c7217cdde317cfec" 
  instance_type = "t2.micro"              # Free tier eligible!
  
  # Attach the security group we defined above
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Use a script to install Docker as soon as the server boots
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              EOF

  tags = {
    Name = "DevOps-Project-Server"
  }
}
# 4. Define the Container Registry (ECR)
# This is where we will upload our Docker Image
resource "aws_ecr_repository" "app_repo" {
  name = "my-flask-app"
}