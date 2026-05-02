# Stage 1: Build documentation site
FROM squidfunk/mkdocs-material AS builder

WORKDIR /docs
COPY . .

RUN mkdocs build

# Stage 2: Serve with Nginx
FROM nginx:alpine

COPY --from=builder /docs/site /usr/share/nginx/html

EXPOSE 80
