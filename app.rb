# frozen_string_literal: true

require "sinatra"

get "/" do
  redirect "/movies"
end

get "/movies" do
  "映画図鑑"
end
