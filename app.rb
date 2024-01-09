require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require 'dotenv/load'

RESULTS_PER_PAGE = 10

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
  page = params.fetch("page", 1).to_i  # Get the requested page number or default to 1
  
  offset = (page - 1) * RESULTS_PER_PAGE  # Calculate the offset based on page number
  
  url = "https://collectionapi.metmuseum.org/public/collection/v1/objects?departmentIds=#{@id}&offset=#{offset}&limit=#{RESULTS_PER_PAGE}"
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
  # Access the parameters using params[:department_id] and params[:object_id]
  department_id = params[:department_id]
  object_id = params[:object_id]
  
  # Your code to fetch data using these IDs
  # ...
  url = "https://collectionapi.metmuseum.org/public/collection/v1/objects?departmentIds=#{department_id}/[#{objectID}]"
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
  
  erb :singlepage # Render your view/template
end
