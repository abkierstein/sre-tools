FROM ubuntu:latest

# Keep apt/dpkg from prompting for input
ARG DEBIAN_FRONTEND=noninteractive

# apt clean is automagically run in the official deb / ubuntu images
# https://github.com/moby/moby/blob/03e2923e42446dbb830c654d0eec323a0b4ef02a/contrib/mkimage/debootstrap#L82-L105
RUN apt update && apt install -y --no-install-recommends \
    # core utilities
    nginx \
    ca-certificates \ 
    software-properties-common \
    duf \
    curl \
    wget \
    less \
    zip unzip \
    # network debugging
    inetutils-ping \
    net-tools \
    dnsutils \
    tcpdump \
    netcat \
    # general
    git \
    stress \
    vim \
    awscli \
    openssh-client \
    redis-tools

# Install eksctl https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
    | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/local/bin && \
    eksctl version

# Install tfenv https://github.com/tfutils/tfenv#manual
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
    ln -s ~/.tfenv/bin/* /usr/local/bin && \
    tfenv install latest && tfenv use latest && \
    terraform version

# Copy nginx files to proper directory
COPY nginx/sites-available/default /etc/nginx/sites-available/
COPY nginx/www/index.html /var/www/html/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
