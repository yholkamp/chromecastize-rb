# Chromecastize-rb

Simple video file conversion script that can be executed from crontab and can be limited to run only within a certain time span.

# Requirements

* ruby
* ffmpeg


# Usage

1. Copy `config.yml.sample` to `config.yml` and edit the configuration values to suit your needs.
2. Execute `ruby chromecastize.rb`

Optionally, you may call the script with `ruby chromecastize.rb pattern`, where `pattern` is a folder pattern that may contain an astrisk, i.e. `~/video/my.series.s01*`. This will convert all files that match the provided pattern(s).



Thanks to https://github.com/bc-petrkotek/chromecastize for the inspiration and groundwork.
