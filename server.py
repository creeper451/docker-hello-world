from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
import socketserver
import os
from datetime import datetime

PORT = int(os.getenv('PORT', 8000))

class CustomHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        # Log the client IP and request
        client_ip = self.client_address[0]
        print(f"{datetime.now()} - {client_ip} - {self.path}")
        
        # Write IP to a file
        with open('client_ip.txt', 'w') as f:
            f.write(client_ip)
        
        # Serve the file as normal
        super().do_GET()

    def log_message(self, format, *args):
        # Disable default logging to stderr
        return

with ThreadingHTTPServer(("", PORT), CustomHandler) as httpd:
    print(f"Serving on port {PORT}")
    httpd.serve_forever()
