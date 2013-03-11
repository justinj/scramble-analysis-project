task :clean do
  sh "rm -rf scrambles"
  mkdir "scrambles"
  sh "rm data/data_results.yml" if File.exist?("data/data_results.yml")
end

task :run do
  sh "./lib/runner.rb data/data.yml"
end

task :"3x3" do
  sh "./lib/runner.rb data/3x3.yml"
end
