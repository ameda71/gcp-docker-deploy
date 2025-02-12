# Use an Nginx image as base
FROM nginx:alpine

# Copy the HTML content into the container's nginx directory
COPY simple.html /usr/share/nginx/html/index.html

# Expose port 80 to access the web server
EXPOSE 80
