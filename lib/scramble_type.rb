require_relative "analysis_job"

class ScrambleType
  def initialize scrambler
    @scrambler = scrambler    
    @name = scrambler["name"]
    @generator = scrambler["generator"] || File.read(scrambler["generator_source"])
    @scramble_file = scrambler["scramble_list"] || "scrambles/#@name"
  end

  def generate_scrambles
    if File.exist?(@scramble_file)
      $LOGGER.info "#@name already has scrambles generated..."
    else
      $LOGGER.info "Scrambles for #@name not generating, generating..."
      $LOGGER.info "scrambler generator is #{@generator}"
      scrambler = Ramsdel::Scrambler.new(@generator)

      File.open(@scramble_file, 'w') do |file|
        $count.times { file.puts(scrambler.next) }
      end

      $LOGGER.info "done"
    end

    $LOGGER.info "scramble file is #{@scramble_file}"
  end

  def calculate_stat stat
    if @scrambler[stat]
      $LOGGER.info "stat #{stat} already calculated, skipping..."
    else
      $LOGGER.info "stat #{stat} not yet calculated, calculating..."
      job = ScrambleAnalyzer::AnalysisJob.new(@scramble_file, stat) 
      @scrambler[stat] = job.perform
    end
  end
end
