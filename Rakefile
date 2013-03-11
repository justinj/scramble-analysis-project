task :clean do
  sh "rm -rf scrambles"
  mkdir "scrambles"
  sh "rm data/data_dirty.yml" if File.exist?("data/data_dirty.yml")
end

task :run do
  sh "./lib/runner.rb data/data.yml"
end
