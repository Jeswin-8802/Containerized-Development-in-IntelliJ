# https://www.jetbrains.com/help/clion/prerequisites.html

# https://docs.docker.com/build/building/multi-stage/
FROM ubuntu

ENV JAVA_HOME=/opt/java/openjdk
# copies everything from temurin's JAVA_HOME to the one we are building
COPY --from=eclipse-temurin:17-jdk $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

LABEL maintainer="Jeswin Santosh jeswin.santosh@outlook.com"

ARG user=jeswins-dev
ARG password=jeswins
ENV HOME /home/${user}

# Update the package list, install sudo, create a non-root user
RUN apt-get update && \
    apt-get upgrade -y && \
    apt install -y tree vim wget git net-tools openssh-server && \
    adduser --disabled-password $user && \
    echo "$user:$password" | chpasswd

# https://wiki.alpinelinux.org/wiki/Setting_up_a_new_user

RUN mkdir -p $HOME/.ssh/log && \
    cp -r /etc/ssh/sshd_config $HOME/.ssh && \
    chmod 644 $HOME/.ssh/sshd_config && \
    chown -R $user $HOME/.ssh

# setup maven
ENV MAVEN_VERSION 3.9.4
ENV MAVEN_HOME  /opt/apache-maven-${MAVEN_VERSION}
ENV PATH $MAVEN_HOME/bin:$JAVA_HOME/bin:$PATH
RUN wget https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz -S \
    && tar -xzf /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt \
    && rm -f /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz

ENV ENV="/etc/profile"
RUN echo "alias ll=\"ls -alhtrF\"\nalias vi=vim\nservice --status-all" >> $ENV

RUN mkdir -p $HOME/.m2 $HOME/GitHub && \
    chown -R $user $HOME/.m2 $HOME/GitHub && \
    chmod 755 -R $HOME/GitHub

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

USER $user

# Set the working directory
WORKDIR ${HOME}