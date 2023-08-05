# Containerized Development in IntelliJ

Build and run a container with `Java`, `Maven` and `ssh` configured and installed with a non-root user.

Run the container as a remote ssh server that can be used with `Jetbrains Gateway` to enable remote development in a container.

# Prerequisites

* `Docker`
* `Jetbrains Gateway`
* `ssh`

> **Note:** *As of writing this file, Jetbrains-Gateway is only available for **Jetbrains Ultimate** users*

# Configure User

Change the username and password in **Dockerfile**

```
ARG user=jeswins-dev
ARG password=jeswins
```

# Build & Run

```
docker build -t java-dev-ubuntu .
```

```
docker run --name java-dev-ubuntu-v3 -p 2200:22 -p 8080:8080 -v ${HOME}/.m2:/home/jeswins-dev/.m2 -v ${HOME}/Documents/GitHub:/home/jeswins-dev/GitHub -it -d java-dev-ubuntu
```
***Note:** change just the username used in the path if it has been changed in Dockerfile; when modifying the mount points, Dockerfile must also be modified @line:42-44*

### The container should be up and running.

### Test the ssh connection:

```
ssh -vvv jeswins-dev@127.0.0.1 -p 2200
```
*use the username configured if changed; **-vvv** preferred for debug*

```
gawk -i inplace '!/127.0.0.1/' ~/.ssh/known_hosts
```
*clear known_hosts before starting a session into a new container; This is assuming your host keys are stored in $HOME/.ssh; **Ignore this step if container is already created***

### Once the container is up and running, launch `Jetbrains Gateway` and follow the steps given https://www.jetbrains.com/help/idea/remote-development-a.html#gateway

