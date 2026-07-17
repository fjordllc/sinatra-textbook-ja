# frozen_string_literal: true

require "json"
require "rack/utils"
require "securerandom"
require "sinatra"

MOVIES_FILE = File.join(__dir__, "data", "movies.json")

helpers do
  def h(value)
    Rack::Utils.escape_html(value)
  end
end

def load_movies
  JSON.parse(File.read(MOVIES_FILE))
end

def save_movies(movies)
  File.write(MOVIES_FILE, "#{JSON.pretty_generate(movies)}\n")
end

def movie_params
  {
    "title" => params["title"].to_s,
    "director" => params["director"].to_s,
    "year" => params["year"].to_s,
    "genre" => params["genre"].to_s,
    "description" => params["description"].to_s
  }
end

get "/" do
  redirect "/movies"
end

get "/movies" do
  @movies = load_movies
  erb :index
end

get "/movies/new" do
  @movie = {}
  @errors = []
  erb :new
end

post "/movies" do
  @movie = movie_params
  @errors = []

  if @movie["title"].strip.empty?
    @errors << "タイトルを入力してください"
    return erb :new
  end

  movies = load_movies
  movies << { "id" => SecureRandom.uuid }.merge(@movie)
  save_movies(movies)

  redirect "/movies"
end
