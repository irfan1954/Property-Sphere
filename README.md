Rails app generated with [lewagon/rails-templates](https://github.com/lewagon/rails-templates), created by the [Le Wagon coding bootcamp](https://www.lewagon.com) team.

To get schema up to date follow step-by-step:
Locations first as propertys require a location reference (dependent)
  1. rake locations:generate - created core table
  2. rake locations:enrich - adds additional data
Once locations generated and enriched
  3. rails db:seed - created properties
  4. rake amenities:generate

Locations
- generated from Office of National Statistics "ONS Postcode Directory (February 2023) for the UK (V2)" (https://geoportal.statistics.gov.uk/datasets a2f8c9c5778a452bbf640d98c166657c/about)
- enriched with crime, average purchase price and average rent price
  - crime - 2023 total reported crimesfrom Metropolitan Police Service "MPS Borough Level Crime" (https://data.london.gov.uk/dataset/recorded_crime_summary)
  - purchase_price - 2021 average purchase price from Office of National Statistics "Residential property sales for subnational geographies: HPSSA dataset 21" (https://www.ons.gov.uk/peoplepopulationandcommunity/housing/datasets/numberofresidentialpropertysalesforsubnationalgeographieshpssadataset21)
  - rent_price - 2019 average rent price from London Datastore "Average Private Rents, Borough" (https://data.london.gov.uk/dataset/average-private-rents-borough)

Amenities
- generated from GoogleNearbyPlaces API from a Hammersmith co-odinate point for the below sites:
  - hospital
  - pharmacy
  - supermarket
  - primary_school
  - secondary_school
  - subway_station
  - train_station
