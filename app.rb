require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require 'dotenv/load'

get("/") do 
  url = "https://collectionapi.metmuseum.org/public/collection/v1/departments"
  response = HTTP.get(url)
  
  if response.body.empty?
    @data = "No response received from API"
  else
    begin
      @data = JSON.parse(response.body)
    rescue JSON::ParserError
      @data = "Response is not valid JSON"
    end
  end
  erb(:home)
end
