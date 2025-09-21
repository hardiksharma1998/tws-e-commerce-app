# ---- Base Stage ----
    FROM node:18-alpine AS base
    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY . .
    RUN npm run build
    
    # ---- Production Stage ----
    FROM nginx:alpine
    WORKDIR /usr/share/nginx/html
    
    # Copy the built application from the build stage
    COPY --from=base /app/next.config.js /usr/share/nginx/html/
    COPY --from=base /app/public /usr/share/nginx/html/public
    COPY --from=base /app/.next/static /usr/share/nginx/html/.next/static
    COPY --from=base /app/.next/server/pages /usr/share/nginx/html/.next/server/pages
    COPY --from=base /app/.next/server/chunks /usr/share/nginx/html/.next/server/chunks
    
    # Copy a custom Nginx configuration file
    COPY nginx.conf /etc/nginx/conf.d/default.conf
    
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]
    