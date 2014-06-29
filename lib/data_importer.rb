require 'google_drive'
require 'io/console'

class DataImporter
  DOCS_KEY = "0AmHC-getEWGbdGRRSmFnV2RjWko5SE5CZWpUS1g2OEE"

  def self.import
    if ENV["USER"] && ENV["PASS"]
      username = ENV["USER"]
      password = ENV["PASS"]
    else
      print "Google username: "
      username = STDIN.gets.chomp

      print "Google password: "
      password = STDIN.noecho(&:gets).chomp
      puts
    end

    new(username, password).import
  end

  attr_reader :username, :password

  def initialize(username, password)
    @username = username
    @password = password
  end

  def import
    rows_with_flags.each do |row|
      data = {
        continent:        row[0],
        name:             row[1],
        category:         row[2].to_i,
        population:       row[3].to_i,
        area:             row[4].to_i,
        image_url:        row[5],
        incorrect_colors: incorrect_colors_for(row),
      }

      write(data);
    end
  end

  private
  def incorrect_colors_for(row)
    row[9..13].select { |c| !c.empty? }.map { |c| c.gsub("#", "") }
  end

  def rows_with_flags
    rows.select do |row|
      row.any? { |s| s.match(/http/) }
    end
  end

  def rows
    session = GoogleDrive.login(username, password)
    spreadsheet = session.spreadsheet_by_key(DOCS_KEY)
    worksheet = spreadsheet.worksheets.first

    worksheet.rows
  end

  def write(data)
    directory = "flags/Puzzles/#{data.fetch(:name)}"

    if File.directory?(directory)
      metadata = "#{directory}/metadata.json"
      File.open(metadata, "w") { |f| f.puts data.to_json }
    else
      puts ">>> No directory: #{directory}"
    end
  end

end
