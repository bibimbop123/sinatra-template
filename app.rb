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
      @data = JSON.parse(response.body).fetch("departments")
    rescue JSON::ParserError
      @data = "Response is not valid JSON"
    end
  end
  erb(:home)
end

get("/:department_id") do
  @id = params.fetch("department_id")

  url = "https://collectionapi.metmuseum.org/public/collection/v1/objects?departmentIds=#{@id}"
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
  erb(:departments)
end

get "/:department_id/:object_id" do
  department_id = params[:department_id]
  object_id = params[:object_id]
  
  url = "https://collectionapi.metmuseum.org/public/collection/v1/objects?departmentIds=#{department_id}/[#{object_id}]"
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
  
  erb :singlepage 
end
