$LOAD_PATH << "lib"

require "data_importer"

task default: [:unzip, :import]

task :unzip do
  puts "Unzipping flags..."
  sh "unzip -q -o flags.zip -d flags/Puzzles"
  sh "rm -rf flags/Puzzles/__MACOSX"
end

task :import do
  puts "Importing data..."
  DataImporter.import
end

task :clean do
  ["7.1", "7.1-64"].each do |version|
    simulator = File.expand_path('~/Library/Application\ Support/iPhone\ Simulator')
    sh "rm -rf #{simulator}/#{version}/Applications/*"
  end
end
