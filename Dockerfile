FROM busybox:latest
ENV PORT=8000
LABEL maintainer="Chris <c@crccheck.com>"

# Create directory structure
RUN mkdir -p /www/cgi-bin /var/log

# Add our custom index.html and a simple shell script
ADD index.html /www/index.html
ADD update_ip.sh /www/cgi-bin/update_ip.sh
RUN chmod +x /www/cgi-bin/update_ip.sh

# Create empty log file
RUN touch /var/log/httpd.log

# HEALTHCHECK CMD nc -z localhost $PORT

# Start httpd and a background process to log IPs
CMD echo "httpd started" && \
    trap "exit 0;" TERM INT; \
    httpd -v -p $PORT -h /www -f 2>&1 | \
    awk '{print > "/var/log/httpd.log"; if($3 == "GET") system("/www/cgi-bin/update_ip.sh "$1)}' & \
    wait
