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
    software-properties-common \
    openssh-client

# Copy nginx files to proper directory
COPY nginx/sites-available/default /etc/nginx/sites-available/
COPY nginx/www/index.html /var/www/html/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
