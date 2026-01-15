# ===============================
# Stage 1: Build the application
# ===============================
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml first to leverage Docker cache
COPY pom.xml .

# Download dependencies (offline cache)
RUN mvn -B dependency:go-offline

# Copy source code
COPY src ./src

# Build the application
# Skip tests and formatting checks (Docker best practice)
RUN mvn package -DskipTests -Dspring-javaformat.skip=true

# ===============================
# Stage 2: Runtime image
# ===============================
FROM eclipse-temurin:17-jre

WORKDIR /run

# Copy JAR from build stage
COPY --from=build /app/target/spring-petclinic-*.jar petclinic.jar

# Expose Spring Boot port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "petclinic.jar"]
