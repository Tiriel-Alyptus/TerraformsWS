#!/bin/bash
sudo yum update
sudo yum install -y apache2
echo "Hello There" | sudo tee /var/www/html/index.html
