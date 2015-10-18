# Chromecastize-rb

Simple video file conversion script that can be executed from crontab and can be limited to run only within a certain time span.

# Requirements

* ruby
* ffmpeg


# Usage

First, copy `config.yml.sample` to `config.yml` and edit the configuration values to suit your needs.
Next, execute `ruby chromecastize.rb`

Optionally, you may call the script using `ruby chromecastize.rb /your/path/here/partial_filename*`, which will convert all files that match the provided pattern(s).



# Thanks

Thanks to https://github.com/bc-petrkotek/chromecastize for the inspiration and groundwork.