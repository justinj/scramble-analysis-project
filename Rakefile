task :clean do
  sh "rm -rf scrambles"
  mkdir "scrambles"
  Dir.glob("data/*_results.yml").each do |file|
    rm file if File.exist?(file)
  end
end

task :run do
  sh "./lib/runner.rb data/data.yml"
end

task :"3x3" do
  sh "./lib/runner.rb data/3x3.yml"
end
