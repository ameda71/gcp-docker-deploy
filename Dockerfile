# Use official Ubuntu as base image
FROM ubuntu:20.04

# Install Apache web server
RUN apt-get update && apt-get install -y apache2

# Copy the HTML file to the Apache web directory
COPY index.html /var/www/html/index.html

# Expose the port Apache runs on
EXPOSE 80

# Start Apache in the background when the container runs
CMD ["apache2ctl", "-D", "FOREGROUND"]
