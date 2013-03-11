#!/usr/bin/env ruby

require "logger"
require "fileutils"
require "yaml"
require_relative "scramble_type"
require_relative "ramsdel/lib/scrambler"

yaml_file = ARGV[0]
results_file = yaml_file.gsub(".yml","_results.yml")

FileUtils.cp(yaml_file, results_file) unless File.exist?(results_file)

data = YAML.load_file results_file
scramblers = data["scramblers"]
count = data["scramble_count"]

def write(data, results_file)
  # backup in case we somehow terminate in the middle of saving
  FileUtils.cp(results_file, "data/yaml_backup")
  File.open(results_file, 'w') { |file| file.write(data.to_yaml) }
end

$LOGGER = Logger.new(STDOUT)

STATS = %w(eo co cross corners edgedist)

scramblers.each do |scrambler|
  $LOGGER.info "=====#{scrambler["name"]}====="
  scramble_type = ScrambleType.new(scrambler)
  scramble_type.generate_scrambles(count)

  STATS.each do |stat|
    scramble_type.calculate_stat stat
    write(data, results_file)
  end
end
