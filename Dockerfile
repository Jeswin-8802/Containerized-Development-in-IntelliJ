# https://www.jetbrains.com/help/clion/prerequisites.html

# https://docs.docker.com/build/building/multi-stage/
FROM ubuntu

ENV JAVA_HOME=/opt/java/openjdk
# copies everything from temurin's JAVA_HOME to the one we are building
COPY --from=eclipse-temurin:17-jdk $JAVA_HOME $JAVA_HOME

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
RUN wget https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz -S \
    && tar -xzf /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt \
    && rm -f /opt/apache-maven-$MAVEN_VERSION-bin.tar.gz

# save for all users
RUN echo "PATH=\"${MAVEN_HOME}/bin:${JAVA_HOME}/bin:${PATH}\"\n" \
    "export MAVEN_HOME=\"${MAVEN_HOME}\"\n" \
    "export JAVA_HOME=\"${JAVA_HOME}\"" >> /etc/environment

RUN touch /run/motd.dynamic.new && \
    chown $user /run/motd.dynamic.new && \
    echo "cat /run/motd.dynamic.new\nservice --status-all" >> /etc/profile

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# set the current user
USER $user

# Set the working directory
WORKDIR ${HOME}
