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
***Note:** change just the username used in the path if it has been changed in Dockerfile*

### The container should be up and running.

### Test the ssh connection:

```
ssh -vvv jeswins-dev@127.0.0.1 -p 2200
```
*use the username configured if changed; **-vvv** preferred for debug*

> make sure that the `.m2/` and and `GitHub/` folders are writable by the USER set in the environment

> if not, execute `chown -R $USER $HOME/.m2 $HOME/GitHub` inside the container.

```
// if you get the error
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
// run
gawk -i inplace '!/127.0.0.1/' ~/.ssh/known_hosts
```
*clear known_hosts before starting a session into a new container; This is assuming your host keys are stored in **$HOME/.ssh***

### Once the container is up and running, launch `Jetbrains Gateway` and follow the steps given at [Connect and work with JetBrains Gateway](https://www.jetbrains.com/help/idea/remote-development-a.html#gateway)

---

<br>

![image](https://github.com/Jeswin-8802/Containerized-Development-in-IntelliJ/assets/84562594/2d93021b-f082-4f97-af12-7ba430dd16e9)

