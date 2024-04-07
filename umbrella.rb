require "http"
require "json"

#GMAPS API -------------------------------------------------------------

pp "Where are you located?"
#user_location = gets.chomp

user_location = "Chicago"
pp user_location

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

response = HTTP.get(maps_url)
raw_response = response.to_s

parsed_response = JSON.parse(raw_response)
results =  parsed_response.fetch("results")

first_result = results[0]
geo = first_result.fetch("geometry")
location = geo.fetch("location")
lat = location.fetch("lat")
lng = location.fetch("lng")

pp lat
pp lng


#WEATHER API -------------------------------------------------------------


weather_url = "https://api.pirateweather.net/forecast/" + ENV.fetch("PIRATE_WEATHER_KEY") + "/" + lat.to_s + "," + lng.to_s

pp weather_url 
response2 = HTTP.get(weather_url)
raw_response2 = response2.to_s

parsed_response2 = JSON.parse(raw_response2)

current = parsed_response2.fetch("currently")
current_temp = current.fetch("temperature")

puts "It is currently #{current_temp}°F."

#NEXT HOUR -------------------------------------------------
minutely_hash = parsed_response2.fetch("minutely", false)

if minutely_hash
  next_hour_summary = minutely_hash.fetch("summary")

  puts "Next hour: #{next_hour_summary}"
end

# PRECIPITATION -------------------------------------------------


