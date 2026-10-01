
FROM alpine:3.20

RUN apk add --no-cache bash curl tzdata tzdata

COPY health_check.sh /app/health_check.sh
RUN chmod +x /app/health_check.sh

CMD ["/app/health_check.sh"]
