#!/usr/bin/env ruby

require "fileutils"
require "yaml"
require_relative "analysis_job"
require_relative "ramsdel/lib/scrambler"

$yaml_file = ARGV[0]
$dirty_yaml_file = $yaml_file.gsub(".yml","_dirty.yml")

FileUtils.cp($yaml_file, $dirty_yaml_file) unless File.exist?($dirty_yaml_file)

$data = YAML.load_file $dirty_yaml_file
$count = $data["scramble_count"]

STATS = %w(eo co cross corners edgedist)

def write
  FileUtils.cp($dirty_yaml_file, "data/yaml_backup")
  File.open($dirty_yaml_file, 'w') { |file| file.write($data.to_yaml) }
end

def log s
  puts s 
end

$data["scramblers"].each do |scrambler|
  log "-----#{scrambler["name"]}-----"
  scramble_file = "scrambles/#{scrambler["name"]}"

  unless File.exist?(scramble_file)
    log "Scrambles for #{scrambler["name"]} not generating, generating..."
    source = File.read(scrambler["generator"])
    log "scrambler generator is #{source}"
    generator = Ramsdel::Scrambler.new(source)

    File.open(scramble_file, 'w') do |file|
      $count.times { file.puts(generator.next) }
    end

    log "done"
  end

  log "scramble file is #{scramble_file}"

  STATS.each do |stat|
    if scrambler[stat]
      log "stat #{stat} already calculated, skipping..."
    else
      log "stat #{stat} not yet calculated, calculating..."
      job = ScrambleAnalyzer::AnalysisJob.new(scramble_file, stat) 
      scrambler[stat] = job.perform

      write
    end
  end
end
