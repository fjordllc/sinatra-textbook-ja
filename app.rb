# frozen_string_literal: true

require "sinatra"

enable :method_override

get "/" do
  redirect "/movies"
end

get "/movies" do
  "<h1>映画図鑑</h1>"
end

