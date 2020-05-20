require "sinatra"
require "sinatra/reloader"
require "httparty"
def view(template); erb template.to_sym; end

get "/" do
  ### Get the weather
  # Evanston, Kellogg Global Hub... replace with a different location if you want
  lat = 42.0574063
  long = -87.6722787

  units = "imperial" # or metric, whatever you like
  key = "ea579953661604a97a00a0b0af0a9d5c" # replace this with your real OpenWeather API key

  # construct the URL to get the API data (https://openweathermap.org/api/one-call-api)
  url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{lat}&lon=#{long}&units=#{units}&appid=#{key}"

  # make the call
  @forecast = HTTParty.get(url).parsed_response.to_hash
    puts "It is currently #{@forecast["current"]["temp"]} degrees with #{@forecast["current"]["weather"][0]["description"]}"
    puts "Extended forecast:"
    day_number = 1
    for day in @forecast["daily"]
        puts "On day #{day_number}, A high of #{day["temp"]["max"]} with #{day["weather"][0]["description"]}"
        day_number = day_number + 1
    end
  ### Get the news

    url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=d43d1ad46bc04b56943a9bb321cc589b"
    @news = HTTParty.get(url).parsed_response.to_hash
    @todaysnews = @news ["articles"][0,10]

  view 'news'


end