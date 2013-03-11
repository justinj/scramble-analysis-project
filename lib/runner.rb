#!/usr/bin/env ruby

require "logger"
require "fileutils"
require "yaml"
require_relative "scramble_type"
require_relative "ramsdel/lib/scrambler"

$yaml_file = ARGV[0]
$results_file = $yaml_file.gsub(".yml","_results.yml")

FileUtils.cp($yaml_file, $results_file) unless File.exist?($results_file)

$data = YAML.load_file $results_file
$count = $data["scramble_count"]

STATS = %w(eo co cross corners edgedist)

def write
  FileUtils.cp($results_file, "data/yaml_backup")
  File.open($results_file, 'w') { |file| file.write($data.to_yaml) }
end

$LOGGER = Logger.new(STDOUT)

$data["scramblers"].each do |scrambler|
  $LOGGER.info "-----#{scrambler["name"]}-----"
  scramble_type = ScrambleType.new(scrambler)
  scramble_type.generate_scrambles

  STATS.each do |stat|
    scramble_type.calculate_stat stat

    write
  end
end
