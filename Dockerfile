# Use a Node.js base image for building the application
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the Next.js application for production
# This command generates the optimized production build
RUN npm run build

# Use a lean Node.js base image for the final production image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the builder stage
# This keeps the final image size minimal
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json .
COPY --from=builder /app/public ./public

# Expose the port on which the Next.js app runs
# Next.js defaults to port 3000
EXPOSE 3000

# Set the command to start the Next.js server
CMD ["npm", "start"]
