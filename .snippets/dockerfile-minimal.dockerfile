FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /app
COPY . .
CMD ["/app/entrypoint.sh"]
