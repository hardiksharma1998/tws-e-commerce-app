# ---- Base Stage ----
# Use a Node.js image to build the Next.js application
FROM node:18-alpine AS base
WORKDIR /app

# Copy package.json and package-lock.json and install dependencies
# This is a key optimization to leverage Docker's layer caching
COPY package*.json ./
RUN npm install

# Copy the rest of the application source code
COPY . .

# Run the Next.js build command
RUN npm run build

# ---- Production Stage ----
# Use a lightweight Nginx image to serve the application
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy the built application from the base stage
# This includes the server, static assets, and next configuration
COPY --from=base /app/next.config.js /usr/share/nginx/html/
COPY --from=base /app/public /usr/share/nginx/html/public
COPY --from=base /app/.next /usr/share/nginx/html/.next
COPY --from=base /app/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for the Nginx server
EXPOSE 80

# The command to run Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
