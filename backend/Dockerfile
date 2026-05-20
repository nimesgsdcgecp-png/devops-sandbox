# ==========================================
    # STAGE 1: Build the application
    # ==========================================
    # Use a heavy image that includes the Java 17 Development Kit
    FROM eclipse-temurin:17-jdk-alpine AS builder

    # Set the working directory inside the container
    WORKDIR /app

    # Copy the Maven wrapper and configuration files first
    COPY .mvn/ .mvn
    COPY mvnw pom.xml ./
    
    # Ensure the wrapper is executable (a Stage 1 Linux concept!)
    RUN chmod +x mvnw

    # Download dependencies (this caches the downloads so future builds are faster)
    RUN ./mvnw dependency:go-offline

    # Copy your actual source code (the controllers, configuration, etc.)
    COPY src ./src

    # Compile the code into a .jar file, skipping tests for speed
    RUN ./mvnw clean package -DskipTests

    # ==========================================
    # STAGE 2: The Production Runtime
    # ==========================================
    # Use a tiny image that ONLY contains the Java Runtime Environment (no compiler)
    FROM eclipse-temurin:17-jre-alpine

    WORKDIR /app

    # Copy ONLY the compiled .jar file from the 'builder' stage above
    COPY --from=builder /app/target/*.jar app.jar

    # Document that this container listens on port 8080
    EXPOSE 8080

    # The command to execute when the container starts
    ENTRYPOINT ["java", "-jar", "app.jar"]
