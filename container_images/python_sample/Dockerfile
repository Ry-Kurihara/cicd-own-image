FROM amazonlinux:2

RUN yum install sudo -y
# install Java 8
RUN yum install java-1.8.0-openjdk -y
# ref: https://api-docs.treasuredata.com/en/tools/cli/quickstart#Amazon-Linux
RUN curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent4.sh | sh

# You need to set these two parameter after launch container
RUN td apikey:set THIS_IS_DUMMY_APIKEY
RUN td server:endpoint https://api.treasuredata.co.jp

RUN echo Y | td workflow

# Install necessary packages for Python3
RUN yum install -y gcc openssl-devel bzip2-devel libffi-devel wget tar gzip make \
    && yum clean all

# Set the Python version we want to install
ENV PYTHON_VERSION=3.9.13

# Download, compile, and install Python
# ref: https://qiita.com/hiren/items/17984191da2ab8955174
RUN cd /opt \
    && wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
    && tar xzf Python-$PYTHON_VERSION.tgz \
    && cd Python-$PYTHON_VERSION \
    && ./configure --enable-optimizations \
    && make altinstall \
    && rm -f /opt/Python-$PYTHON_VERSION.tgz

RUN echo 'alias python=python3.9' >> ~/.bashrc
RUN source ~/.bashrc

# これをすることでpipコマンドが使えるようになる。upgrade前ではpip: command not foundとなる。
RUN pip3.9 install --upgrade pip

# package install
RUN pip install boto3==1.28.4
RUN pip install pytest==7.4.0
RUN pip install pytest-mock==3.11.1
RUN pip install requests==2.31.0
