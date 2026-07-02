# ---------- STAGE 1: Build ----------
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Pura multi-module project copy karo (root pom sab modules verify karta hai)
COPY . .

# Sirf product-service build karo, common ko bhi automatically build karega (-am)
RUN mvn -pl product-service -am clean package -DskipTests -B


# ---------- STAGE 2: Run ----------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=build /app/product-service/target/*.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]

