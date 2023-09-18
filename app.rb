require "sinatra"
require "sinatra/reloader"
require "http"




get("/") do
erb:home
end

get("/umbrella") do
  erb:umbrella_form
end

post("/process_umbrella") do
  @user_location = params.fetch("user_loc")
  encoder =  @user_location.gsub(" ", "+")

  gmaps_url="https://maps.googleapis.com/maps/api/geocode/json?address=#{encoder}&key=AIzaSyDKz4Y3bvrTsWpPRNn9ab55OkmcwZxLOHI"
  
  @result = HTTP.get(gmaps_url).to_s
  @parsed_result = JSON.parse(@result)
  @loc_hash = @parsed_result.dig("results", 0, "geometry", "location")
  @lat = @loc_hash.fetch("lat")
  @lng = @loc_hash.fetch("lng")

  pirate_weather = "https://api.pirateweather.net/forecast/3RrQrvLmiUayQ84JSxL8D2aXw99yRKlx1N4qFDUE/#{@lat},#{@lng}"

  @weather_result = HTTP.get(pirate_weather)
  response = JSON.parse(@weather_result)
  @currently = response.fetch("currently")
  @temperature = @currently.fetch("temperature")
  @summary = @currently.fetch("summary")


  precip_probability = @currently.fetch("precipProbability")

  if precip_probability > 0.10
    @result = "You might want to take an umbrella!"
  else
    @result = "You probably won't need an umbrella."  
  end
 
  erb:umbrella_response
end


AI_KEY = ENV.fetch("AI_KEY")

get("/message") do
  erb:ai_message_form
end

get("/process_single_message") do
  erb(:message_response)
end

get("/chat") do
  erb:ai_chat_form
end
