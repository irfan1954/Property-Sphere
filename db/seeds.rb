# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# API or website (scrape) with street address, postcode and a deescription

puts "Cleaning user database"
User.destroy_all

puts "Seeding user DB"
test_user = User.new(
  email: "test@test.com",
  password: "123456",
)
test_user.save

puts "Users seeded!"

puts "Cleaning properties DB"
Property.destroy_all
puts "Seeding properties DB"


CSV.foreach("lib/addresses.csv", headers: true) do |address|
  types = ["flat","house", "terraced house", "semi-detached house"]

  image_urls =
    [
    "https://lid.zoocdn.com/u/1024/768/cca732c73fe8aa661362d92ce65ea868ab511039.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/3016b5ac1f7d1b342aac74a49b3cbf820e146fe6.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/7c0d9dbb3fafcd1b41fd43f8603a66d5dc701a85.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/7f7fc3403414b6a7a88c83aef416c087e0d24740.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/d6a4d6ab7ddcc28df706ad32e063964912d678be.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/86d3f159705afc446534d5d81ee2174d9f17952d.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/fda7a7aa24700c508231718c6c7ea3c528b99cf3.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/b5e0ed642fa1c3afd79f036eb54e090bc4342dcc.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/456905e455947e2cf6733054f59cbbecbbfa120a.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/ffc84a44ce170479458ff13879cdaa98695873ea.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/6f8c8c65ec86c54e6709b35b7f0e8090a9f9503c.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/9dba0322ffcbf4815094d6c1ed8afbac34087eb5.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/776489a94add85618ce2ae104b69510bc9b769a2.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/a26cf51d56c41f2862cd15785498318f4c198892.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/967f30fcff4bb7163d0d4b6f2a869b58fa141ef0.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/475c52e36803eb5c130fa13ab5d2d84030b13c41.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/86b75d2b9d03db572dc3515c3f898fab5612b670.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/72f685680f7ffe5b99d0aa226abec1529c0f6acd.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/62a23c1206e885f15a8f18a96bf077f89bb2ac55.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/8eec55a8859b1468a7826013af11e5235795a4cd.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/d32511fe50044130f15bf0e86ebad2945b4857ad.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/1f70859ff962ddd08d577e3b47812b20216948e3.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/29914095acdc1ec5fbef5dec6ebbfa64ae31f3d7.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/f0e22dbd8ebab1b6fa7367e32bba7e90e26bbad9.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/d15d3f0bdd4ae7e425108f2816fe9a8e98fed49e.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/e5cfceae004123dfb9a80e1e55069a03937e39c7.jpg:p",
    "https://lid.zoocdn.com/u/1024/768/21b83a1ccaa72ff967b215df572038ee348d9a4d.png:p"
  ]

  images = 5.times.map do
    image_urls.sample
  end

  address_hash = {
    street_address: address["﻿Address"],
    postcode_string: address["Postcode"],
    description: Faker::Lorem.paragraph,
    bedrooms: rand(1..5),
    bathrooms: rand(1..3),
    garden: ["true", "false"].sample,
    image_urls: images,
    council_tax: ["A", "B", "C", "D", "E"].sample,
    property_type: types.sample,
    floor_area: rand(45.0...120.0),
    postcode_id: Postcode.find_by(postcode: address["Postcode"].delete(" ")).id
  }
  Property.create!(address_hash)
end

puts "Seeded recommendations DB"
puts "Seeding has been completed!"
puts "IMPORTANT: Test user login below..."
puts "======= email: test@test.com ======="
puts "========= password: 123456 ========="



# image urls

# inside property




# property image
# https://lid.zoocdn.com/u/1024/768/ce3cb4c0253c3d3a1311bd35335dfc89aa33153c.jpg:p
# https://lid.zoocdn.com/u/1024/768/bb0b34cfd8be5b4ef3e1a63e994c80a7b76d649e.jpg:p
# https://lid.zoocdn.com/u/1024/768/755a0dd84852c7e1efbb3e0f54e134e94c4b15e5.jpg:p
# https://lid.zoocdn.com/u/1024/768/08c838ff29577a8865340b5542fd16074e4d8463.jpg:p
# https://lid.zoocdn.com/u/1024/768/5e1f67579afbd7822e49f1af9adfd268bf48de33.jpg:p
# https://lid.zoocdn.com/u/1024/768/42760a7d69f22ea802e95810f9517f2dafc18bd2.jpg:p
# https://lid.zoocdn.com/u/1024/768/7e7e361e9a35c73c772d0d82882f0ac7eea3bf0b.jpg:p
# https://lid.zoocdn.com/u/1024/768/dac7482a2aad96bc4e389c13e40afd71260a18e4.jpg:p
# https://lid.zoocdn.com/u/1024/768/7f8667edcf008badc136a3d50525e78421eebf2c.jpg:p
# https://lid.zoocdn.com/u/1024/768/e6d71cd019aeedaccf77030414f0858ad74330b4.jpg:p
# https://lid.zoocdn.com/u/1024/768/b052ab5e346aa1a987175f1188a513c5b960fe05.jpg:p
# https://lid.zoocdn.com/u/1024/768/96055036fb9d75812a7cf4b78adc73b69305bc33.jpg:p
# https://lid.zoocdn.com/u/1024/768/97cc85e8656ab7599526dd37c29a1a546e51d718.jpg:p
# https://lid.zoocdn.com/u/1024/768/c10d3f64366af901e0a047bf4bd89f45788a62be.jpg:p
# https://lid.zoocdn.com/u/1024/768/5402632f1bcbb339c99e4572fb3b3ef5532c132d.jpg:p
# https://lid.zoocdn.com/u/1024/768/d5cf4a27a829ce57eda32655a3c0a49fe96279e2.jpg:p
# https://lid.zoocdn.com/u/1024/768/a11ea73300e15d37670fd4f348bd3fdd0968441a.jpg:p
# https://lid.zoocdn.com/u/1024/768/057343023dcd00f9ced00d32a73fc31e9b3d8068.jpg:p
# https://lid.zoocdn.com/u/1024/768/a35b56531efe46ac931a731f6705010bf8970243.jpg:p
# https://lid.zoocdn.com/u/1024/768/eba141c689dc11082ee9cb495a8ac48b021146f3.jpg:p
# https://lid.zoocdn.com/u/1024/768/5a98b4aab8eb6b6f3043f18db5c49fac5e8a503c.jpg:p
# https://lid.zoocdn.com/u/1024/768/8905ab08eaf780a0001fbe6cce3765a687154f58.jpg:p
# https://lid.zoocdn.com/u/1024/768/4f8bbfd9f0b259dcd9104f2ed46250e67e94d378.jpg:p
# https://lid.zoocdn.com/u/1024/768/5e7317fa9de1bd470297a1111648e4166247ca42.jpg:p
