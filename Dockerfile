# Use the official Nginx base image
FROM nginx:latest

# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/nginx.conf

# Copy your custom Nginx configuration file
COPY ./nginx.conf /etc/nginx/

# Create a directory for your HTML files
RUN mkdir -p /usr/share/nginx/html

# Copy your static HTML files to the container
COPY ./html/ /usr/share/nginx/html/

# Expose port 80 for Nginx
EXPOSE 80

# Define the default command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
