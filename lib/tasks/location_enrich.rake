require 'csv'
require 'google/apis/places_v1'
require "json"
require "open-uri"
require 'humanize'

# import single csv file into the database, requires creation of table for import data "ONSData"
namespace :locations do
  desc "imports locations from ONS data and populates the locations table"
  task :enrich => :environment do
    puts "=== Enriching location data with crime data..."
    enrich_start_time = Time.now

    Location.pluck(:layer_code).uniq.each.with_index do |layer_code, index|

     crime_csv = "MPS LSOA Level Crime (most recent 24 months).csv"
     layer_code_crimes = []
     CSV.foreach("lib/files/crime/#{crime_csv}", headers: true) do |row|
       if layer_code == row["LSOA Code"]
         total_crime = [
           row["202301"].to_i, row["202302"].to_i, row["202303"].to_i,row["202304"].to_i,
           row["202305"].to_i,row["202306"].to_i,row["202307"].to_i,row["202308"].to_i,row["202309"].to_i,
           row["202310"].to_i,row["202311"].to_i, row["202312"].to_i
         ].sum
         layer_code_crimes.push(total_crime)
       end
     end

     unless layer_code_crimes.empty?
       Location.where(layer_code: layer_code).update_all(
         crime: layer_code_crimes.sum,
         )
     end

     if Location.where(layer_code: layer_code).crime == nil
       p Location.where(layer_code: layer_code)
     end


      if index % 10 == 0
        puts "Enriched #{index} layer codes with crime data "
      end
    end

    # puts "=== Now enriching with purchase price data"

    # Location.pluck(:layer_code).uniq.each.with_index do |layer_code, index|

    #   purchase_price_csv = "hpssa202103.csv"
    #   layer_code_purchase_prices = []
    #   CSV.foreach("lib/files/purchase_price/#{purchase_price_csv}", headers: true) do |row|
    #     purchase_price = row["hpmd202103"].to_i
    #     if layer_code == row["lsoacode"]
    #       layer_code_purchase_prices.push(purchase_price)
    #     end
    #   end

    #   unless layer_code_purchase_prices.empty?
    #     Location.where(layer_code: layer_code).update_all(
    #       purchase_price: (layer_code_purchase_prices.sum/layer_code_purchase_prices.count),
    #       )
    #   end

    #   if index % 10 == 0
    #     puts "Enriched #{index} layer codes with purchase price data "
    #   end
    # end

    # puts "=== Now enriching with rent price data"

    # Location.pluck(:borough).uniq.each.with_index do |borough, index|
    #   rental_price_csv = "voa-average-rent-borough.csv"
    #   borough_rental_prices = []
    #   CSV.foreach("lib/files/rental_price/#{rental_price_csv}", headers: true) do |row|
    #     next if row["Year"] != "2019"
    #     rental_price = row["Average"].to_i
    #     if borough == row["Code"]
    #       borough_rental_prices.push(rental_price)
    #     end
    #     # ADDITION TO SEPERATE BY BEDROOMS/CATEGORY
    #     #  category = row["Category"]
    #     #  Property.all do |property|
    #     #     if category == "#{property.bedrooms.humanize} Bedroom"
    #     #       property.rental_price = rental_price
    #     #     end
    #     #  end
    #   end

    #   unless borough_rental_prices.empty?
    #     Location.where(borough: borough).update_all(
    #       rent_price: borough_rental_prices.sum
    #       )
    #   end

    #   if index % 10 == 0
    #     puts "Enriched #{index} boroughs with crime and purchase price data "
    #   end

    # end
    enrich_end_time = Time.now
    puts "============================================"
    puts "COMPLETE! Enriched location data in #{(enrich_end_time - enrich_start_time)/60} minutes!"
    puts "============================================"
  end
end
