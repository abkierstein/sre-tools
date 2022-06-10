FROM ubuntu:latest

# apt clean is automagically run in the official deb / ubuntu images
# https://github.com/moby/moby/blob/03e2923e42446dbb830c654d0eec323a0b4ef02a/contrib/mkimage/debootstrap#L82-L105
RUN apt update && apt install -y --no-install-recommends \
    inetutils-ping \
    net-tools \
    dnsutils \
    curl \
    ca-certificates \ 
    stress \
    tcpdump \
    wget \
    netcat \
    vim \
    nginx \
    awscli \
    software-properties-common

# Copy nginx files to proper directory
RUN rm -rf /var/www/html/*
ADD nginx-site/ /var/www/html/
RUN sed -ie 's|/var/log/nginx/access.log|off|' /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
