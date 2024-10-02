require "kemal"
require "http/client"
require "uri/params"
require "http/headers"
require "json"
require "qr-code"

get "/" do |env|
  env.redirect "/index.html"
end

post "/register" do |env|
  params = URI::Params.encode({"first_name" => env.params.body["firstname"], "last_name" => env.params.body["lastname"], "email" => env.params.body["email"]})
  res = HTTP::Client.post("https://api.libib.com/patrons?#{params}", headers: HTTP::Headers{"x-api-key" => ENV["LIBIB_KEY"], "x-api-user" => ENV["LIBIB_USER"]})
  res_j = JSON.parse res.body
  email = res_j["email"].as_s
  barcode = res_j["barcode"].as_s
  svg_s = QRCode.new(res_j["barcode"].as_s, level: :h).as_svg
  render "src/views/register.ecr"
end

Kemal.run
