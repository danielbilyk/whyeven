# Whyeven

<div align="center">
  <br>
  <img src="images/logo.png" width="256" alt="">
</div>

Welcome to the little corner of podcasting mayhem.

This project sprang to life one fateful evening when a motley crew of TUM-based computer science students, and I – political science student at one of the most prominent technical universities of the country – decided that my self-hosted podcasting workflow needed a dash of automation. I wrote, recorded, edited, sounddesigned, published and hosted my podcasts myself, so I needed a way to:
a) auto-fill the RSS feed for each of the shows with necessary information;
b) back it all up to my NAS;
c) try to do it in one evening, two at max.

The name of the project – Whyeven – is self-descriptive. You'll be asking yourself this question many times during the installation and setup process. I did too. This is where the motto "because we can, not because we should" takes on a life of its own.

But it isn't just a project; it's an adventure in over-engineering when you have nothing but a little Bash and AppleScript knowledge; an ode to unnecessary complexity, and a testament to what happens when you leave nerds in a dorm room with too much free time and a penchant for the absurd.

So, if you're ready to dive into the world where bash scripts and Automator workflows come together in a spectacular display of "why on earth did they do it this way," you've come to the right place. Let's make podcasting a little less tedious and a lot more... interesting.

## Prerequisites

Before you embark on this journey of questionable coding decisions, you'll need:
- A macOS machine (because apparently, we love exclusivity)
- Automator and Terminal, because who needs a GUI when you have the command line?
- The bash script (`extra-steps.sh`), nestled safely in a directory of your choice.
- A sense of humor and possibly a strong drink.

## Installation

1. **Place the Bash Script**: Ensure the `extra-steps.sh` script is located in a directory of your choice. Remember the path to this script.

2. **Automator Workflow Setup**:
    - Open Automator and create a new "Application" workflow.
    - Add a "Run AppleScript" action.
    - Copy the generalized AppleScript provided above into the script editor within Automator. Make sure to replace `/path/to/your/script/extra-steps.sh` with the actual path to where you placed `extra-steps.sh`.
    - Save the Automator Application in a convenient location, such as your Applications folder or Desktop.

3. **Modify the Bash Script**: Open `extra-steps.sh` in a text editor and adjust paths and configurations as necessary to fit your setup. This may include changing directory paths, URL formats, and other podcast-specific configurations as detailed in the bash script section above.

4. You also need your own server, possibly a NAS, and definitely a podcast or two.

## Usage

1. **Prepare Your Audio File**: Ensure your audio file is ready for processing.

2. **Run the Automator Workflow**:
    - Drag and drop your audio file onto the Automator Application icon. This will start the workflow.
    - Follow the prompts to select the appropriate podcast, enter the episode title, and ensure your show notes are ready.
    - The bash script will then process the audio file according to the configurations set in `extra-steps.sh`.

3. **Final Steps**:
    - The script will update RSS feeds, upload files to the server, and perform any other configured actions.
    - You'll receive a notification once the process is complete.

## Additional Setup Note

Before you get too excited, let's make sure you have all the necessary tools installed. This project, in its divine wisdom, uses a smorgasbord of programming languages to define text variables in the script. Here's what you'll need:

- PHP for parsing filenames because... why not?
- Node.js to figure out what year it is (in case you've lost track)
- Python to slice and dice episode titles
- AWK, because we felt like it needed some love too
- Lua to handle date formatting, adding that exotic flair
- Perl, just to say we did
- FFMPEG for audio file info, because at least one choice had to make sense
- Ruby to generate UUIDs, because clearly, we hadn't used enough languages yet

Ensure each of these executables is installed and accessible from your command line. If you're thinking, "This seems like overkill," then congratulations, you're starting to understand the essence of this project.

## Troubleshooting

- **Script Permissions**: Ensure `extra-steps.sh` has executable permissions. Run `chmod +x /path/to/your/script/extra-steps.sh` in Terminal if necessary.
- **Automator Errors**: If the Automator workflow fails to run, check the script for syntax errors and ensure all paths are correctly set.

## Customization

Feel free to tweak, twist, and turn this project into whatever you need it to be. Just remember, with great power comes great responsibility – or in our case, with great over-engineering comes great headaches.

Enjoy your journey into this labyrinth of podcast automation. May your feeds always be updated, and your spirits high.
