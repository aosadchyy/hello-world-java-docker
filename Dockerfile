FROM registry.access.redhat.com/ubi8/openjdk-11 as build

LABEL name="Java hello world app" \
    maintainer="Alex Osadchyy"

USER root
WORKDIR /workspace
COPY src ./src
COPY pom.xml ./
# Install build dependencies
RUN --mount=type=cache,target=/root/.cache/microdnf:rw \
    microdnf --setopt=cachedir=/root/.cache/microdnf --nodocs install \
    maven
# Build java app
RUN mvn install


#########################################


FROM registry.access.redhat.com/ubi8/ubi-minimal:8.8

ARG DEPENDENCY=/workspace/target

LABEL BASE_IMAGE="registry.access.redhat.com/ubi8/ubi-minimal:8.8"
LABEL JAVA_VERSION="11"

RUN microdnf install --nodocs java-11-openjdk-headless && microdnf clean all

COPY --from=build ${DEPENDENCY}/*.jar /app/application.jar
WORKDIR /app

EXPOSE 8080
CMD ["java", "-jar", "application.jar"]