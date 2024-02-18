#!/bin/bash

theFilename=$1
thePodcast=$2
theTitle=$3
theShownotes=$4 # Be sure to have the shownotes in HTML format

# User-specific folders
user_projects_folder="/path/to/projects" # Adjust this path to your projects directory
# NAS
nas_podcasts_folder="/path/to/nas/projects" # Adjust this path to your NAS directory
# Webserver
web_podcasts_folder="/var/www/podcasts" # Adjust this path accordingly
podcasts_url="https://yourdomain.com/podcasts" # Adjust the domain accordintly

# Setup podcast-specific config

case $thePodcast in

  "Podcast 1")
    artist="Artist Name"
    album="Podcast 1"
    user_project_folder="$user_projects_folder/Podcast-1"
	nas_podcast_folder="$nas_podcasts_folder/Podcast-1"
    web_podcast_folder="$web_podcasts_folder/Podcast-1"
	podcast_url="$podcasts_url/Podcast-1"
	rss_filename="podcast-1.xml"
    theShownotes=$(cat <<EOF
$theShownotes
<p>Show-specific always-present links or information goes here.</a>.</p>
EOF
)
    ;;

  "Podcast 2")
    artist="Artist Name"
    album="Podcast 2"
    user_project_folder="$user_projects_folder/Podcast-2"
	nas_podcast_folder="$nas_podcasts_folder/Podcast-2"
    web_podcast_folder="$web_podcasts_folder/Podcast-2"
	podcast_url="$podcasts_url/Podcast-2"
	rss_filename="podcast-2.xml"
    ;;

  *)
    say "tea doll boy yob"
    exit 0
    ;;
esac

# Create or use specific directories based on the podcast name, removing spaces and special characters
sanitized_podcast_name=$(echo "$thePodcast" | tr " " "_" | sed 's/[^a-zA-Z0-9_]//g')

user_projects_folder="$user_podcasts_folder/$sanitized_podcast_name"
nas_podcast_folder="$nas_podcasts_folder/$sanitized_podcast_name"
web_podcast_folder="$web_podcasts_folder/$sanitized_podcast_name"
podcast_url="$podcasts_url/$sanitized_podcast_name"
rss_filename="${sanitized_podcast_name,,}.xml" # Convert to lowercase for the RSS filename

# Customize shownotes with static ever-present links or information if needed
theShownotes=$(cat <<EOF
$theShownotes
<p>Additional show-specific notes or links can go here.</p>
EOF
)

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
if ls "$user_projects_folder/$audio_filename" > /dev/null 2>&1; then
    rm "$user_projects_folder/$audio_filename"
fi
/usr/local/bin/ffmpeg -i "$theFilename" -i "$user_projects_folder/logo.png" -map_metadata 0 -map 0 -map 1 -metadata title="$theTitle" -metadata artist="$artist" -metadata album="$album" -metadata genre="Podcast" -metadata date="$year" -b:a 168k "$user_projects_folder/$audio_filename" > /dev/null 2>&1

# Update RSS XML with new episode details
# Here you might want to adjust how the new RSS item is generated based on your needs. For example

search_string="<!-- DO NOT REMOVE THIS COMMENT -->"
case $thePodcast in 

    "Podcast 1")
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
    
    "Podcast 2")
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
echo "$(/usr/local/bin/php -r "echo str_replace('$search_string', '$new_rss_item', file_get_contents('$user_projects_folder/$rss_filename'));")" > "$user_projects_folder/$rss_filename"

# Upload new episode and RSS to server
scp "$user_project_folder/$audio_filename" user@yourserver.com:$web_podcast_folder > /dev/null
scp "$user_projects_folder/$rss_filename" user@yourserver.com:$web_podcast_folder > /dev/null

# Backup MP3 and XML to NAS
if [ -d "$nas_podcast_folder" ]; then
	cp "$user_project_folder/$audio_filename" "$nas_podcast_folder"
	cp "$user_projects_folder/$rss_filename" "$nas_podcast_folder"
else
	say "NAS is not mounted"
	# `say` won't work on non Mac computers
fi

# Delete audio file
rm "$theFilename"
