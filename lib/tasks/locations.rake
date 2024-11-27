require 'csv'
require 'google/apis/places_v1'
require "json"
require "open-uri"

# import single csv file into the database, requires creation of table for import data "ONSData"
namespace :locations do
  desc "imports locations from ONS data and populates the locations table"
  task :generate => :environment do

    start_time = Time.now
    puts "Starting to destroy postcodes..."
    Location.delete_all
    end_time = Time.now
    puts "Destroyed all postcodes in #{end_time - start_time} seconds"

    postcode_csv_dir = "lib/files"
    import_start_time = Time.now
    Dir.foreach(postcode_csv_dir) do |filename|
      next unless filename.end_with?(".csv")
      puts "----- Now parsing #{filename} -----"
      CSV.foreach("lib/files/#{filename}", headers: true).with_index do |row, index|

        if index % 1000 == 0
          puts "-"
          puts "Parsed #{index} postcodes in #{filename} "
          puts "Created #{Location.count} postcodes so far"
        end

        next if row["doterm"].present?
        row_hash = {
            postcode: row["pcds"].delete(" "),
            lat: row["lat"].to_f,
            long: row["long"].to_f,
            borough: row["lsoa11"],
            layer_code: row["oslaua"],
            demographic: row["oac11"],
            constituency: row["pcon"],
            afluence: row["imd"]
          }
        Location.insert!(row_hash)
      end
    end
    import_end_time = Time.now
    puts "=============================="
    puts "COMPLETE! Imported #{Location.count} postcodes in #{(import_end_time - import_start_time)/60} minutes!"
    puts "=============================="
  end

end
