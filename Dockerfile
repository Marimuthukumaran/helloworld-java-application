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
COPY --from=build /target/*.jar /helloworld.jar

# Run Command: java -jar /app.jar
ENTRYPOINT ["java", "-jar", "/helloworld.jar"]
