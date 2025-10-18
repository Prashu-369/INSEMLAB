# Step 1: Build stage (Node.js for React/Vite)
FROM node:18 AS build-stage

# Set working directory in the container
WORKDIR /app

# Install dependencies and build the app
RUN apt-get update && apt-get install -y git

# Clone the frontend repository (you can skip this if you already have the source code)
RUN git clone https://github.com/suneethabulla/carrental-frontend.git .

# Install npm dependencies and build the React app
RUN npm install
RUN npm run build

# Step 2: Runtime stage (Tomcat for serving)
FROM tomcat:9-jdk17

# Remove the default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the build output from the build stage to Tomcat's webapps directory
COPY --from=build-stage /app/dist /usr/local/tomcat/webapps/ROOT

# Expose Tomcat port
EXPOSE 8082

# Start Tomcat server
CMD ["catalina.sh", "run"]
