#!/bin/bash
#le repertoire debs est un répertoire qui contient tout le ficiher .deb que l'on vient de copier
echo -e "Content-Type: text/html\n\n"
echo "<html>"
echo "<head>"
echo "<title>deb</title>"
echo "</head>"
echo "<body>"
echo "<h1>Index of /debs</h1>"
echo "<ul>"
for file in /var/www/html/debs/*.deb; do
    name=$(basename "$file")
    echo "<li><a href=\"/debs/$name\" download>$name</a></li>"
done
echo "</ul>
echo "</body>"
echo "</html>"

