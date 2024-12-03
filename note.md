Search implementation

1. Create backend action to get all postcodes from the loaction's table (on any view that has the search)
2. Return postcodes from 1. above
3. Create a search input field
4. Using Stimulus js, hide all postcodes if user hasn't inputted any text (Use TomSelect for this)
5. Show postcodes based on user input
6. Get user postcode inputted and retrieve the lat and long of the post code.
7. Get all properties within postcode radius and return the search.
