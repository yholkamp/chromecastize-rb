# Usage: ruby chromecastize.rb <optional priority file>
require 'yaml'
config = YAML.load_file('config.yml')

SUPPORTED_VIDEO_CODECS = ["AVC"]
SUPPORTED_AUDIO_CODECS = ['AAC', 'MPEG Audio', 'Vorbis', 'Ogg']
DEFAULT_VIDEO = "h264"
DEFAULT_AUDIO = "aac"
DRY_RUN = false

def output_formats(video_file)
  file_info = `mediainfo "#{video_file}"`
  if $?.success?
    puts "Retrieved mediainfo for video file #{video_file}"
  else
    puts "Could not retrieve mediainfo for video file #{video_file}"
    return nil
  end

  current_vcodec = /Video\n.+\nFormat\s+:\s(\w+)/.match(file_info)[1]
  current_acodec = /Audio\n.+\nFormat\s+:\s(\w+)/.match(file_info)[1]

  video_supported = SUPPORTED_VIDEO_CODECS.include?(current_vcodec)
  audio_supported = SUPPORTED_AUDIO_CODECS.include?(current_acodec)

  if video_supported && audio_supported
    puts "#{video_file} requires no recording"
    nil
  else
    video_codec = if video_supported
                    puts "Video requires no recording"
                    "copy"
                  else
                    puts "Video requires recording, #{current_vcodec} is not supported"
                    DEFAULT_VIDEO
                  end

    audio_codec = if audio_supported
                    puts "Audio requires no recording"
                    "copy"
                  else
                    puts "Audio requires recoding, #{current_acodec} is not supported"
                    DEFAULT_AUDIO
                  end

    [video_codec, audio_codec]
  end
end

def convert_file(config, video_file)
  output_video, output_audio = output_formats(video_file)
  return if output_video.nil?

  time = Time.now
  command = %{ffmpeg -loglevel error -stats -i "#{video_file}" -map 0 -scodec copy -vcodec "#{output_video}" -acodec "#{output_audio}" -strict -2 "#{video_file}.tmp.mkv" > ffmpeg_output.log}
  if DRY_RUN
    puts "Would have executed this command:\n#{command}"
    return
  else
    output = system(command)
  end

  if output
    puts "Converted video file #{video_file} in #{Time.now - time} seconds"
  else
    puts "Failed to convert file #{video_file}"
    `mv ffmpeg_output.log "error.#{video_file.split("/").last}.log"`
    return
  end

  # Move original to backup folder
  `mv "#{video_file}" "#{config["backup_dir"]}"` if config["backup_dir"]

  # Move tmp to original
  `mv "#{video_file}.tmp.mkv" "#{video_file.gsub("."+video_file.split(".").last, ".mkv")}"`
end


if ARGV.count > 0
  files = []
  ARGV.each do |priority_file|
    Dir.glob(priority_file) do |filepath|
      files << filepath
    end
  end

  puts "Converting #{files.count} files"
  files.each {|filepath| convert_file(config, filepath) }

  exit
end

config["scan_dirs"].map do |target_path|
  Dir.glob(target_path + "/*").each do |path|
    matching_files = Dir.glob(path + "/*").select do |filename|
      ["mkv", "avi", "mpg", "mp4"].any? {|x| filename.downcase.end_with? x } && File.stat(filename).size > 10**8
    end

    puts "Found #{matching_files.count} video files in folder #{path}"
    matching_files.each {|video_file| convert_file(config, video_file)}

    if config["run_until"] && Time.now.strftime("%H:%M") > config["run_until"]
      puts "Exiting due to lack of time"
      break
    end
  end
end