FROM adoptopenjdk/openjdk8:alpine-slim as builder
WORKDIR /app
RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline
USER k8s-pipeline
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} ./app.jar

FROM adoptopenjdk/openjdk8:alpine-slim
WORKDIR /home/k8s-pipeline
COPY --from=builder /app/app.jar ./
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]