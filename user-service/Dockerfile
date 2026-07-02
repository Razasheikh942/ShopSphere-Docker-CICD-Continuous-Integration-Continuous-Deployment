# ---------- STAGE 1: Build ----------
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Pura multi-module project copy karo (zaroori hai, kyunki root pom sab modules verify karta hai)
COPY . .

# Sirf user-service build karo, common ko bhi automatically build karega (-am)
RUN mvn -pl user-service -am clean package -DskipTests -B


# ---------- STAGE 2: Run ----------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=build /app/user-service/target/*.jar app.jar

EXPOSE 8083

ENTRYPOINT ["java", "-jar", "app.jar"]