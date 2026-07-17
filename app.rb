# frozen_string_literal: true

require "sinatra"

movies = [
  {
    "id" => "b6f5e1c4-4b5f-4a7f-8f8f-3d9d3ef9d001",
    "title" => "月面喫茶",
    "director" => "山田アキラ",
    "year" => "2042",
    "genre" => "SF",
    "description" => "月面にある小さな喫茶店を舞台にした物語。"
  },
  {
    "id" => "b6f5e1c4-4b5f-4a7f-8f8f-3d9d3ef9d002",
    "title" => "北風のリズム",
    "director" => "佐藤ミナ",
    "year" => "2038",
    "genre" => "ドラマ",
    "description" => "雪の町で古い楽器を修理する人々を描く。"
  },
  {
    "id" => "b6f5e1c4-4b5f-4a7f-8f8f-3d9d3ef9d003",
    "title" => "週末ロケット",
    "director" => "鈴木トオル",
    "year" => "2040",
    "genre" => "コメディ",
    "description" => "町工場の仲間たちが小さなロケット作りに挑む。"
  }
]

get "/" do
  redirect "/movies"
end

get "/movies" do
  @movies = movies
  erb :index
end

get "/movies/new" do
  erb :new
end

post "/movies" do
  content_type :text
  params.inspect
end
