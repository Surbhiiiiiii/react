# Use Node.js for building the React app
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Use Apache2 as the web server
FROM httpd:alpine

# Remove default Apache index page
RUN rm -rf /usr/local/apache2/htdocs/*

# Copy built React app to Apache's serving directory
COPY --from=build /app/build /usr/local/apache2/htdocs/

# Expose port 80 for web access
EXPOSE 80

# Start Apache in foreground mode
CMD ["httpd", "-D", "FOREGROUND"]
