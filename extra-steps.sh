#!/bin/bash

theFilename=$1
thePodcast=$2
theTitle=$3
theShownotes=$4

# MacBook
mac_podcasts_folder="/Users/dani/Projects/FM"
# NAS
pi_podcasts_folder="/Volumes/SSDani/Projects/FM"
# Webserver
web_podcasts_folder="/var/www/podcasts"
podcasts_url="https://podcasts.bilyk.gq"

# Setup podcast-specific config
case $thePodcast in

  "Para Pablo")
    artist="Daniel Bilyk"
    album="Para Pablo"
    mac_podcast_folder="$mac_podcasts_folder/Para Pablo"
	pi_podcast_folder="$pi_podcasts_folder/Para Pablo"
    web_podcast_folder="$web_podcasts_folder/ParaPablo"
	podcast_url="$podcasts_url/ParaPablo"
	rss_filename="parapablo.xml"
    theShownotes=$(cat <<EOF
$theShownotes
<p>You’ll find the Spotify playlist <a href="https://open.spotify.com/playlist/1evRRLtrtSVlX8LhV9klZD?si=8ae8cc02ad104b88">here</a>.</p>
EOF
)
    ;;

  "Lockдауны" | "Lockдауны_Dev")
    artist="Даня и Камчатка"
    album="Lockдауны"
    mac_podcast_folder="$mac_podcasts_folder/Lockdowns"
	pi_podcast_folder="$pi_podcasts_folder/Lockdowns"
    web_podcast_folder="$web_podcasts_folder/lockdowns"
	podcast_url="$podcasts_url/lockdowns"
	if [[ $thePodcast = "Lockдауны_Dev" ]]; then
		rss_filename="lockdowns_dev.xml"
	else
		rss_filename="lockdowns.xml"
	fi
	theShownotes=$(cat <<EOF
$theShownotes
<p>Ссылки-ссылочки на себя и вот это всё:</p><ul>
<li>	<a href="https://www.instagram.com/raspberden/">Instagram</a> Камчатки</li>
<li>	<a href="https://t.me/bilykchannel">Канал</a> Дани</li>
<li>	<a href="https://t.me/gomurmel">Канал</a> Камчатки </li></ul>
EOF
)
    ;;
    
  "Интеллектуалы.FM" | "Интеллектуалы.FM-Dev")
    artist="Daniel Bilyk"
    album="Интеллектуалы.FM"
    mac_podcast_folder="$mac_podcasts_folder/Intellectuals.FM"
	pi_podcast_folder="$pi_podcasts_folder/Intellectuals.FM"
    web_podcast_folder="$web_podcasts_folder/Intellectuals.FM"
	podcast_url="$podcasts_url/intellectualsfm"
	if [[ $thePodcast = "Интеллектуалы.FM-Dev" ]]; then
		rss_filename="intellectualsfm_dev.xml"
	else
		rss_filename="intellectualsfm.xml"
	fi
	theShownotes=$(cat <<EOF
$theShownotes
<p>Наш плейлист на Spotify можно найти <a href="https://open.spotify.com/playlist/1QHWF9ScBStxATQOYGIaUD?si=3f9f26b2411a4c96">вот тут</a>.</p>
EOF
)
    ;;

  "Cony Cassettes")
    artist="Daniel Bilyk"
    album="Cony Cassettes"
    mac_podcast_folder="$mac_podcasts_folder/Cony Cassettes"
	pi_podcast_folder="$pi_podcasts_folder/Cony Cassettes"
    web_podcast_folder="$web_podcasts_folder/ConyCassettes"
	podcast_url="$podcasts_url/ConyCassettes"
	rss_filename="conycassettes.xml"
    ;;

  *)
    say "tea doll boy yob"
    exit 0
    ;;
esac

# Define all text variables
audio_filename=$(/usr/local/bin/php -r "echo basename('$theFilename');")
year=$(/usr/local/bin/node -e "console.log(new Date().getFullYear())")
episode_number=$(/usr/bin/python3 -c "print('$theTitle'[0:'$theTitle'.find(': ')])")
episode_name=$(/usr/bin/awk -F ': ' '{print $2}' <<< "$theTitle")
episode_pubdate=$(/usr/local/bin/lua -e 'print(os.date("%a, %d %B %Y %H:%M:%S %Z"))')
episode_size=$(/usr/bin/perl -e "print -s '$theFilename';")
episode_duration=$(/usr/local/bin/ffmpeg -i "$theFilename" 2>&1 | grep Duration | cut -d ' ' -f 4 | sed s/,// | cut -d '.' -f 1)
episode_guid=$(/usr/bin/ruby -e 'require "securerandom"' -e 'puts SecureRandom.uuid')
episode_url="$podcast_url/$episode_number.mp3"
episode_logo="$podcast_url/logo.png"

# Convert audio to a different bitrate and fill out metadata
if ls "$mac_podcast_folder/$audio_filename" > /dev/null 2>&1; then
    rm "$mac_podcast_folder/$audio_filename"
fi
/usr/local/bin/ffmpeg -i "$theFilename" -i "$mac_podcast_folder/logo.png" -map_metadata 0 -map 0 -map 1 -metadata title="$theTitle" -metadata artist="$artist" -metadata album="$album" -metadata genre="Podcast" -metadata date="$year" -b:a 168k "$mac_podcast_folder/$audio_filename" > /dev/null 2>&1

# Update RSS XML
search_string="<!-- DO NOT REMOVE THIS COMMENT -->"
case $thePodcast in 

    "Lockдауны" | "Lockдауны_Dev")
    new_rss_item=$(cat <<EOF
$search_string
    <item>
        <title>$theTitle</title>
        <itunes:episode>$episode_number</itunes:episode>
        <itunes:title>$episode_name</itunes:title>
        <itunes:author>$artist</itunes:author>
        <pubDate>$episode_pubdate</pubDate>
        <enclosure url="$episode_url" length="$episode_size" type="audio/mpeg"/>
        <itunes:duration>$episode_duration</itunes:duration>
        <itunes:explicit>no</itunes:explicit>
        <itunes:image href="$episode_logo" />
        <guid isPermaLink="false">$episode_guid</guid>
        <description>
            <![CDATA[ $theShownotes ]]>
        </description>
    </item>
EOF
)
    ;;
    
    "Cony Cassettes" | "Para Pablo" | "Интеллектуалы.FM")
    new_rss_item=$(cat <<EOF
$search_string
    <item>
        <title>$theTitle</title>
        <itunes:episode>$episode_number</itunes:episode>
        <itunes:title>$episode_name</itunes:title>
        <itunes:author>$artist</itunes:author>
        <pubDate>$episode_pubdate</pubDate>
        <enclosure url="$episode_url" length="$episode_size" type="audio/mpeg"/>
        <itunes:duration>$episode_duration</itunes:duration>
        <itunes:explicit>no</itunes:explicit>
        <itunes:image href="$episode_logo" />
        <guid isPermaLink="false">$episode_guid</guid>
        <description>
            <![CDATA[ $theShownotes ]]>
        </description>
    </item>
EOF
)
    ;;
esac
echo "$new_rss_item"
echo "$(/usr/local/bin/php -r "echo str_replace('$search_string', '$new_rss_item', file_get_contents('$mac_podcasts_folder/$rss_filename'));")" > "$mac_podcasts_folder/$rss_filename"

# Upload new episode and RSS to server
scp "$mac_podcast_folder/$audio_filename" root@linode.bilyk.gq:$web_podcast_folder > /dev/null
scp "$mac_podcasts_folder/$rss_filename" root@linode.bilyk.gq:$web_podcasts_folder > /dev/null

# Backup MP3 and XML to NAS
if [ -d "$pi_podcast_folder" ]; then
	cp "$mac_podcast_folder/$audio_filename" "$pi_podcast_folder"
	cp "$mac_podcasts_folder/$rss_filename" "$pi_podcasts_folder"
else
	say "Raspberry Pi is not mounted"
fi

# Delete audio file
rm $theFilename