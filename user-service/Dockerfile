FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY common ./common
COPY user-service ./user-service
RUN mvn clean install -N -DskipTests
RUN mvn -pl common clean install -DskipTests
RUN mvn -pl payment-service clean package -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/user-service/target/*.jar app.jar
EXPOSE 8085
ENTRYPOINT ["java", "-jar", "app.jar"]