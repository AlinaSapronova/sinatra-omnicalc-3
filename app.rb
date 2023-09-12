require "sinatra"
require "sinatra/reloader"

get("/") do
erb:home
end

get("/umbrella") do
  erb:umbrella_form
end

post("/process_umbrella") do
  @user_location = params.fetch("user_loc")
  erb:umbrella_response
end

get("/message") do
  erb:ai_message_form
end

get("/process_single_message") do
  erb(:message_response)
end

get("/chat") do
  erb:ai_chat_form
end
