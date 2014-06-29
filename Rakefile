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
