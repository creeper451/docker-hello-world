#!/bin/sh
echo "Content-type: text/html"
echo ""
echo "<html><body>"
echo "<h1>Your IP Address is:</h1>"
if [ -f /www/current_ip.txt ]; then
    tail -n 1 /www/current_ip.txt
else
    echo "No IP detected yet"
fi
echo "</body></html>"
