# Chromecastize-rb

Simple video file conversion script that will take a number of folders containing video files and convert these files in to audio and video codecs supported by the Google Chromecast. This script was developed to convert video files so that Plex Media Server will not transcode video files during playback, which not all NAS hardware supports.

Features include:

* Monitors multiple paths for unconverted files.
* Can be configured to stop converting new files after a certain time using the `run_until` configuration variable. * Creates backup of files that are converted. 

# Requirements

* `ruby`
* `ffmpeg` (available in path)


# Usage

1. Copy `config.yml.sample` to `config.yml` and edit the configuration values to suit your needs.
2. Execute `ruby chromecastize.rb`

Optionally, you may call the script with `ruby chromecastize.rb pattern`, where `pattern` is a folder pattern that may contain an astrisk, i.e. `~/video/my.series.s01*`. This will convert all files that match the provided pattern(s).



Thanks to https://github.com/bc-petrkotek/chromecastize for the inspiration and groundwork.
