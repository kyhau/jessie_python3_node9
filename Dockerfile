FROM python:3.6.4
MAINTAINER Kay Hau <virtualda@gmail.com>
# Based on buildpack-deps:jessie

# Add some environment variables
ENV HOME /root

# Move to a safe place
WORKDIR $HOME

RUN apt-get update && apt-get install -y \
    build-essential=11.7\* \
    curl=7.38.\* \
    git=1:2.1.\* \
    libffi-dev=3.1\* \
    python3-dev \
    sudo=1.8.\*

# Install node
RUN curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
RUN apt-get install -y nodejs
# Install nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

# Install pip via PyPA's recommended way rather than the outdated apt repos
# See: https://pip.pypa.io/en/stable/installing/
RUN curl https://bootstrap.pypa.io/get-pip.py -o ./get-pip.py && \
    python3.6 get-pip.py

# Upgrade pip and install virtualenv
RUN python3.6 -m pip install -U pip virtualenvwrapper wheel

# Install packages for running selenium tests
RUN apt-get update && apt-get install -y \
    libxss1=1:1.2.\* \
    libappindicator1=0.4.\* \
    libindicator7=0.5.\*

# Install chrome for running selenium tests
# See reference: https://newseasandbeyond.wordpress.com/2013/05/26/installing-chrome-on-debian/
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome*.deb; exit 0
RUN apt-get install -f -y
RUN dpkg -i google-chrome*.deb

RUN apt-get autoremove -y

CMD ["/bin/bash"]
