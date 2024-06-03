# A Containerized Hello World Java deployment with Docker and UBI

a very simple rest-api-hello-world java application with Spring Boot and Maven, containerized with dockerfile, ready to build and deployed with a very simple way.
This project also demonstrates how to build a multi-arch version of the Hello World Java app.

## How to Build
```
docker build -t hello-world-java-docker .
```  

## How to Run
```
docker run -it hello-world-java-docker
```

## Building on IBM LinuxONE/IBM Z and creating a multi-arch manifest list
```
sudo dnf install podman buildah
git clone https://github.com/aosadchyy/hello-world-java-docker.git 
cd hello-world-java-docker/ 
podman manifest create hello-world-java
podman build --platform linux/s390x  --manifest hello-world-java:latest .
podman manifest push hello-world-java:latest
```
## Building on x86 and adding to the multi-arch manifest list
```
sudo dnf install podman buildah
git clone https://github.com/aosadchyy/hello-world-java-docker.git 
cd hello-world-java-docker/ 
podman pull hello-world-java:latest
podman build --platform linux/amd64 --manifest hello-world-java:latest .
podman manifest push hello-world-java:latest
```

## Alternatively, one can build multi-arch containers on a single architecture machine e.g. x86 with a quemu emulation of s390x architecture.

## Building on x86 systems for s390x with quemu
e.g.
```
sudo dnf install qemu-user-static
podman build --platform linux/amd64,linux/s390x  --manifest hello-world-java:latest .
```
Using docker buildx is similar to podman
```
docker buildx create --use --name mybuilder
docker buildx inspect --bootstrap
docker buildx build --platform linux/amd64,linux/s390x --output "type=image,push=true" \
--tag hello-world-java:latest --builder mybuilder .
docker buildx stop mybuilder
```

