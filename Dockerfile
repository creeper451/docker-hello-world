FROM busybox:latest
ENV PORT=8000
LABEL maintainer="Chris <c@crccheck.com>"

# Add a script that will generate dynamic HTML with client IP
ADD index.html /www/index.html
ADD client_ip.sh /www/cgi-bin/client_ip.sh
RUN chmod +x /www/cgi-bin/client_ip.sh

# EXPOSE $PORT

HEALTHCHECK CMD nc -z localhost $PORT

# Create a basic webserver that logs client IPs and runs until stopped
CMD echo "httpd started" && \
    trap "exit 0;" TERM INT; \
    httpd -v -p $PORT -h /www -f & \
    while true; do \
        tail -f /var/log/httpd.log | while read line; do \
            if echo "$line" | grep -q "GET /"; then \
                ip=$(echo "$line" | awk '{print $1}'); \
                echo "Client IP: $ip" >> /www/current_ip.txt; \
            fi; \
        done; \
    done & \
    wait
