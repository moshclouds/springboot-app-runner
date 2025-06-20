# ----------- STAGE 1: Build the application -----------
FROM maven:3.9.6-eclipse-temurin-21 as build

# Set work directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy full source code
COPY src ./src

# Package the app
RUN mvn clean package -DskipTests


# ----------- STAGE 2: Run the application -----------
FROM eclipse-temurin:21-jdk-alpine

# Set work directory in final image
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application port
EXPOSE 8890

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]