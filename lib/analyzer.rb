require "ostruct"

module ScrambleAnalyzer
  class Analyzer
    def initialize(file, stat)
      @file = file
      @stat = stat.to_s
    end

    def perform
      output = `#{jarfile_command} #@stat #@file`
      output.split(": ").last.to_f
    end

    def jarfile_command
      "java -jar #{File.dirname(__FILE__)}/speed-scrambles.jar"
    end
  end
end
