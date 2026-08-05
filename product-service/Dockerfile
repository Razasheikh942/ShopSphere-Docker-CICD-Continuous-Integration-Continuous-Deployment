FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY common ./common
COPY product-service ./product-service
RUN mvn clean install -N -DskipTests
RUN mvn -pl common clean install -DskipTests
RUN mvn -pl product-service clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/product-service/target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]