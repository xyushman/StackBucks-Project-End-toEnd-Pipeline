# Use Node.js Alpine base image
FROM node:alpine

# Set environment to production
ENV NODE_ENV=production

# Create and set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first (leverages Docker cache)
COPY package.json package-lock.json ./

# Install exact dependencies securely (omits devDependencies)
RUN npm ci

# Copy the entire codebase
COPY . .

# Change ownership of the app files to the non-root 'node' user
RUN chown -R node:node /app

# Switch to the non-root user for better security
USER node

# Expose the port your container app uses
EXPOSE 3000   

# Define the command to start your application
CMD ["npm", "start"]
