# Use the official Maven image to build the project
FROM maven:3.8.4-openjdk-17-slim as build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src ./src
RUN mvn package -DskipTests

# Use the official OpenJDK image to run the application
FROM eclipse-temurin:17.0.7_7-jdk-focal

# Add a new user "pnp" with user id 8877
RUN useradd -u 8877 pnp

# Create necessary directories and set permissions
RUN mkdir -p /opt/docker/ /templates/ /files/ /tmp && \
    chown -R pnp:pnp /opt /templates /files /tmp

# Change to non-root privilege
USER pnp

# Copy the built jar file from the build stage
COPY --from=build /app/target/*.jar /app.jar

# Run Command: java -jar /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
