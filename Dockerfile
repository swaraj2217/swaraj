# Use an official Maven image to build the app
FROM maven:3.8.7-openjdk-17-slim AS build

# Set working directory in the container
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the WAR file
COPY src /app/src
RUN mvn clean package -DskipTests

# Use a lightweight image to run the app
FROM openjdk:17-jre-slim

# Set working directory in the container
WORKDIR /app

# Copy the WAR file from the build stage
COPY --from=build /app/target/myapp-1.0-SNAPSHOT.war /app/myapp.war

# Expose the port the app runs on
EXPOSE 8080

# Run the WAR file using the Java runtime
CMD ["java", "-jar", "myapp.war"]
