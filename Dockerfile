FROM ubuntu:22.04

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    apache2 \
    subversion \
    libapache2-mod-svn \
    apache2-utils \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create directory for SSL keys
RUN mkdir -p /etc/apache2/ssl.key

# Generate a self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/apache2/ssl.key/server.pem \
    -out /etc/apache2/ssl.key/server.pem \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=localhost"

# Copy configurations and assets
COPY etc/apache2/sites-available/svn.conf /etc/apache2/sites-available/svn.conf
COPY var/svn /var/svn
COPY var/www /var/www

# Enable necessary Apache modules
RUN a2enmod ssl dav dav_svn authz_svn auth_basic alias autoindex deflate dir env mime negotiation status

# Disable the default site and enable our custom SVN site
RUN a2dissite 000-default && a2ensite svn

# Set correct permissions so Apache can read/write repositories
RUN chown -R www-data:www-data /var/svn /var/www

# Expose HTTPS port
EXPOSE 8443

# Start Apache in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
