FROM nginx:alpine 

# Remove default NGINX configuration
RUN rm /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/nginx.conf

# Copy configuration templates (https://devopsian.net/p/nginx-config-template-with-environment-vars/)
COPY conf.d/api_gateway.conf.template /etc/nginx/templates/api_gateway.conf.template
COPY nginx.conf /etc/nginx/nginx.conf

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]