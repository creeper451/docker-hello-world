FROM python:3-alpine
ENV PORT=8000
LABEL maintainer="Chris <c@crccheck.com>"

WORKDIR /app

# Add our custom Python HTTP server script
ADD server.py /app/server.py
ADD index.html /app/index.html

EXPOSE $PORT

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q -O /dev/null http://localhost:$PORT || exit 1

CMD ["python", "server.py"]
