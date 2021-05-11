#!/bin/bash

servername="linode.bilyk.gq"
title=$3
filename=$(/usr/bin/php -r "echo basename('$1');")
year=$(echo -e "import datetime\nprint(datetime.datetime.now().year)" | /usr/bin/python3)

# Setup podcast-specific config
case $2 in

  "Para Pablo")
    artist="Daniel and Luisa"
    album="Para Pablo"
    basepath="/Users/dani/Projects/FM/Para Pablo"
    serverpath="/var/www/podcasts/ParaPablo"
    ;;

  Lockдауны | Lockдауны_Dev)
    artist="Даня и Камчатка"
    album="Lockдауны"
    basepath="/Users/dani/Projects/FM/Lockdowns"
    serverpath="/var/www/podcasts/Lockdowns"
    ;;

  "Cony Cassettes")
    artist="Daniel Bilyk"
    album="Cony Cassettes"
    basepath="/Users/dani/Projects/FM/Cony Cassettes"
    serverpath="/var/www/podcasts/ConyCassettes"
    ;;

  *)
    say "tea doll boy yob"
    exit 0
    ;;
esac

# Convert audio to a different bitrate and fill out metadata
#if ls "$basepath/$filename" > /dev/null 2>&1; then 
#    rm "$basepath/$filename"
#fi
#/usr/local/bin/ffmpeg -i "$1" -i "$basepath/logo.png" -map_metadata 0 -map 0 -map 1 -metadata title="$title" -metadata artist="$artist" -metadata album="$album" -metadata genre="Podcast" -metadata date="$year" -b:a 168k "$basepath/$filename" > /dev/null

# Upload to server
#scp "$basepath/$filename" root@$servername:$serverpath > /dev/null

# Update RSS XML
# /usr/bin/php -r "echo substr("$to", 0, strpos($title, ':'));"
episode_number=$(/usr/bin/php -r "echo substr(\"$title\", 0, strpos(\"$title\", ': '));")
episode_name=$(/usr/bin/php -r "echo substr(\"$title\", strpos(\"$title\", ': ') + 2);")
episode_pubdate=""
episode_url=""
episode_length=""
episode_duration=""
episode_logo=""
episode_guid=""
episode_content=""
new_rss_item="  <item>
        <title>$title</title>
        <itunes:episode>$episode_number</itunes:episode>
        <itunes:title>$episode_name</itunes:title>
        <itunes:author>$artist</itunes:author>
        <pubDate>$episode_pubdate</pubDate>
        <enclosure url=\"episode_url\" length=\"$episode_length\" type=\"audio/mpeg\"/>
        <itunes:duration>$episode_duration</itunes:duration>
        <itunes:explicit>no</itunes:explicit>
        <itunes:image href=\"$episode_logo\" />
        <guid isPermaLink=\"false\">$episode_guid</guid>
        <content:encoded> <![CDATA[ $episode_content ]]>
        </content:encoded>
    </item>"
echo $new_rss_item