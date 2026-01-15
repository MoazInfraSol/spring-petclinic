# Use Maven official image with JDK
FROM maven:latest

# Set working directory inside container
WORKDIR /app

# Copy your project files to container
COPY . /app

# Run formatter plugins
RUN mvn net.revelc.code.formatter:formatter-maven-plugin:2.23.0:format && \
    mvn io.spring.javaformat:spring-javaformat-maven-plugin:0.0.46:apply  \
    mvn package -DskipTests  \
    mvn target/spring-petclinic-3.5.0-SNAPSHOT.jar /run/petclinic.jar

# Build the project skipping tests
#RUN mvn package -DskipTests

# Move the generated jar to /run directory and rename it
#RUN mv target/spring-petclinic-3.5.0-SNAPSHOT.jar /run/petclinic.jar

# Expose the application port
EXPOSE 8080

# Command to run the app jar
CMD ["java", "-jar", "/run/petclinic.jar"]
