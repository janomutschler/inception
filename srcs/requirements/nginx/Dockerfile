FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

# Nginx config
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Entrypoint
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# build arg so the cert CN matches your domain
ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}

# Generate self-signed cert during build (domain is not a secret)
RUN openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/selfsigned.key \
  -out /etc/nginx/ssl/selfsigned.crt \
  -subj "/C=DE/ST=BW/L=Heilbronn/O=42/OU=Inception/CN=${DOMAIN_NAME}"

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]