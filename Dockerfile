FROM ubuntu

# Update and install Apache, wget, unzip
RUN apt update && apt upgrade -y && \
    apt install apache2 wget unzip -y

# Download and unzip the template
WORKDIR /tmp
RUN wget https://www.tooplate.com/zip-templates/2108_dashboard.zip && \
    unzip 2108_dashboard.zip && \
    cp -r 2108_dashboard/* /var/www/html/

# Expose Apache port
EXPOSE 80

# Start Apache directly
CMD ["apachectl", "-D", "FOREGROUND"]
