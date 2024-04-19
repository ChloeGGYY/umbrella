require "http"
require "json"

=begin

# Single string of addresses separated by underscores
address_string = "Nova Brasília_Avenida Itaoca_Rua Nova Brasília_Ramos_Bonsucesso_Praça do Terco_São Paulo_Catacumba_Buraco do Sapo_Itaoca_Avenida Nova Brasília_Alvorada_Inferno Verde_Fazendinha_Barra de Tijuca_Complexo de Alemão_Morro de Alemão_Rocinha_Jacarezinho_Copacabana_Grota_Praça_Rio Grande do Norte_Niteroi_Campo Grande_Sao Gonçalo_Niteroi_Natal_Gloria_Irajá_Japeri_Guadalupe_Estacio de Sá_Niteroi_Santa Cruz_Praça do Terco_João Pessoa_Paraiba_Natal_Rio Grande do Norte"

# Split the string into an array of addresses
addresses = address_string.split("_")

# Google Maps API key
api_key = ENV.fetch("GMAPS_KEY")

# Iterate over each address
addresses.each do |address|
  maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{address}&key=#{api_key}"
  
  # Send the request to the Google Maps API
  response = HTTP.get(maps_url)
  raw_response = response.to_s
  
  # Parse the JSON response
  parsed_response = JSON.parse(raw_response)
  results = parsed_response.fetch("results")
  
  # Check if results were found
  if results.any?
    first_result = results[0]
    geo = first_result.fetch("geometry")
    location = geo.fetch("location")
    lat = location.fetch("lat")
    lng = location.fetch("lng")
    
    # Print the original address and its coordinates
    puts "#{address} (#{lat}, #{lng})"
  else
    puts "No results found for #{address}"
  end
end

=end


#GMAPS API -------------------------------------------------------------

pp "Where are you located?"
#user_location = gets.chomp

user_location = "Chicago"
pp user_location

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + ENV.fetch("GMAPS_KEY")

pp maps_url
require "http"
response = HTTP.get(maps_url)
raw_response = response.to_s


# pp raw_response

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

hourly_hash = parsed_response2.fetch("hourly")
 pp hourly_hash.class
