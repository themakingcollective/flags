$LOAD_PATH << "lib"

require "data_importer"

task default: [:unzip, :import]

def import_patterns
  sh "unzip -q -o patterns.zip -d patterns"
  Dir["patterns/*.png"].each do |f|
    name = File.basename(f).gsub(".png", "")

    source = f
    destination = "flags/Puzzles/#{name}/pattern.png"

    sh "mv #{source} #{destination}"
  end
  sh "rm -rf patterns"
end

task :unzip do
  puts "Importing flags..."
  sh "unzip -q -o flags.zip -d flags/Puzzles"
  sh "rm -rf flags/Puzzles/__MACOSX"

  puts "Importing patterns..."
  import_patterns
end

task import: :unzip do
  puts "Importing data..."
  DataImporter.import
end

task :clean do
  ["7.1", "7.1-64"].each do |version|
    simulator = File.expand_path('~/Library/Application\ Support/iPhone\ Simulator')
    sh "rm -rf #{simulator}/#{version}/Applications/*"
  end

  derived = File.expand_path("~/Library/Developer/Xcode/DerivedData/flags-*")
  sh "rm -rf #{derived}"
end
