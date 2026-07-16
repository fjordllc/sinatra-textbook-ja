# frozen_string_literal: true

require "rack/mock"
require "sinatra/base"

class StackVerificationApp < Sinatra::Base
  enable :method_override

  helpers do
    def h(value)
      Rack::Utils.escape_html(value)
    end
  end

  patch "/movies/:id" do
    status 204
  end

  delete "/movies/:id" do
    status 204
  end

  post "/redirect" do
    redirect "/movies/example-id", 303
  end

  get "/escape" do
    erb "<p><%= h(params[:value]) %></p>"
  end
end

def assert(message)
  raise "Verification failed: #{message}" unless yield

  puts "OK: #{message}"
end

request = Rack::MockRequest.new(StackVerificationApp)
form_headers = { "CONTENT_TYPE" => "application/x-www-form-urlencoded" }

patch_response = request.post(
  "/movies/example-id",
  form_headers.merge(input: "_method=patch")
)
assert("POST with _method=patch reaches the PATCH route") do
  patch_response.status == 204
end

delete_response = request.post(
  "/movies/example-id",
  form_headers.merge(input: "_method=delete")
)
assert("POST with _method=delete reaches the DELETE route") do
  delete_response.status == 204
end

redirect_response = request.post("/redirect")
assert("redirect can return 303 See Other") do
  redirect_response.status == 303 &&
    redirect_response["location"].end_with?("/movies/example-id")
end

escape_response = request.get(
  "/escape",
  params: { value: "</textarea><script>alert(1)</script>" }
)
assert("Rack::Utils.escape_html escapes user input in ERB") do
  escape_response.body.include?("&lt;/textarea&gt;") &&
    !escape_response.body.include?("<script>")
end

puts "Verified Sinatra #{Sinatra::VERSION}, Rack #{Rack.release}"

