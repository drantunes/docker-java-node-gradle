FROM ubuntu:17.10
MAINTAINER Diego R. Antunes

ENV NODE_VERSION 9.6.1
ENV GRADLE_VERSION 4.1

RUN apt-get upgrade
RUN apt-get update && apt-get install -y --no-install-recommends \ 
    openjdk-8-jdk wget curl unzip xz-utils python build-essential ssh git

# Setup certificates in openjdk-8
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
    apt-get install -y nodejs

#Install Yarn
RUN apt-get update && apt-get install -y curl apt-transport-https && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

#Alternative
#RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
#RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#RUN apt-get update && apt-get install -y yarn

#Alternative
#RUN touch ${HOME}/.profile
#RUN curl -o- -L https://yarnpkg.com/install.sh | bash

RUN yarn -v

#Install ionic, cordova
RUN yarn global add ionic cordova
RUN ionic -v
RUN cordova -v

# Set path
ENV PATH ${PATH}:/usr/local/gradle-$GRADLE_VERSION/bin

# Install gradle
RUN wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
    unzip gradle-$GRADLE_VERSION-bin.zip && \
    rm -f gradle-$GRADLE_VERSION-bin.zip

RUN gradle --version

WORKDIR /app
