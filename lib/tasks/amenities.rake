namespace :amenities do
  desc "imports local amenities from Google Places API and populates the amenities table"
  task generate: :environment do

    puts "Destorying Amenities..."
    Amenity.destroy_all
    puts "Amenities destroyed!"
    puts "============================="

    # list of types -> https://developers.google.com/maps/documentation/places/web-service/supported_types?_gl=1*1501w1b*_up*MQ..*_ga*MTM3MTAyNDEyOC4xNzMyNjQwNjU1*_ga_NRWSTWS78N*MTczMjY0MDY1NS4xLjEuMTczMjY0MDY1NS4wLjAuMA..#table2
    types_array = ["hospital","pharmacy","supermarket","primary_school","secondary_school","subway_station"]

    #Hammersmith
    ham_lat = 51.499998
    ham_long = -0.249999
    radius_meters = 15000

    types_array.each do |type|
      url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=#{type}&location=#{ham_lat}%2C#{ham_long}&radius=#{radius_meters}&type=#{type}&key=#{ENV['GOOGLE_API_KEY']}"
      results_string = URI.parse(url).read
      results = JSON.parse(results_string)

      results["results"].each do |result|
        amenity_hash = {
          category: type,
          name: result["name"],
          lat: result["geometry"]["location"]["lat"],
          long: result["geometry"]["location"]["lng"]
        }
        Amenity.create!(amenity_hash)
      end
      puts "Created #{Amenity.where(category: type).count} #{type}s"

      token = results["next_page_token"]
      if token.present?
        until Amenity.where(category: type).count >= 250
          next_url = url + "&#next_page_token=#{token}"

          next_results_string =  URI.parse(next_url).read
          next_results = JSON.parse(next_results_string)

          next_results["results"].each do |result|
            amenity_hash = {
              category: type,
              name: result["name"],
              lat: result["geometry"]["location"]["lat"],
              long: result["geometry"]["location"]["lng"]
            }
            Amenity.create!(amenity_hash)
          end
          puts "Created #{Amenity.where(category: type).count} #{type}s"
        end
      end
    end
  end
end
