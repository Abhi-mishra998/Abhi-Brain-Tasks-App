# Step 1: Use official Nginx image
FROM nginx:alpine

# Step 2: Copy build files from dist folder to nginx html directory
COPY dist /usr/share/nginx/html

# Step 3: Expose port 80 (default for nginx)
EXPOSE 80

# Step 4: Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

