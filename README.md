#Centos4J Dockerfile

An example Dockerfile for a Java webapp based on Centos
----
 * Centos 7
 * JDK 8
 * Maven
 * Tomcat 8
 * Nginx

Prerequisites
-----
I assume you have installed Docker and it is running.

See the [Docker website](http://www.docker.io/gettingstarted/#h_installation) for installation instructions.

Build
-----
Steps to build a Docker image:

####1. Clone this repo

        $git clone https://github.com/lidaco/cent4j.git

####2. Build the image

        $cd cent4j
        $docker build -t="cent4j" ./

        This will take a few minutes.

####3. Run the image's default command, which should start everything up
The `-p` option forwards the container's port 80 to port 8083 on the host.
(Note that the host will actually be a guest if you are using boot2docker, so you may need to re-forward the port in VirtualBox.)

        $docker run -p="8083:80" cent4j

####4. Access Webapp via [http://localhost:8083/](http://localhost:8083/) on your host machine

        open http://localhost:8083/

####You can also login to the image and have a look around with

        $docker run -it cent4j /bin/bash
    