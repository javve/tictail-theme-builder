# BANANABAD CODE.
# You have been warned.

require 'rubygems'
require 'mechanize'
require 'json'
require 'stringex'

if (ARGV.length != 2)
  puts "Script usage: ruby fetcer.rb <tictail-email> <tictail-password>"
  exit
end

agent = Mechanize.new

page = agent.get('https://tictail.com/user/signin')

sign_in_form = page.form()
sign_in_form.email = ARGV[0]
sign_in_form.passwd = ARGV[1]

page = agent.submit(sign_in_form, sign_in_form.buttons.first)

store_id = page.body.scan(/"id": (\d*), "vat_number"/)[0][0]

store = page.body.scan(/var ClientSession = (.*);\n/)[0][0]
store = JSON.parse(store)
store = store["storekeeper"]["stores"].first[1]
store["url"] = "/"

logo = agent.get('https://tictail.com/apiv2/rpc/v1/?jsonrpc={"jsonrpc":"2.0","method":"store.media.logotype.get","params":{"store_id":' + store_id + '},"id":null}').body
logo = JSON.parse(logo)
logo = logo["result"]["logotype"]
logo["sizes"].each do |key, value|
  name = "url-" << key
  logo[name] = value
end
logo.delete("sizes")

description = agent.get('https://tictail.com/apiv2/rpc/v1/?jsonrpc={"jsonrpc":"2.0","method":"store.description.get","params":{"store_id":' + store_id + '},"id":null}').body
description = JSON.parse(description)
description = description["result"]["description"]

navigation = agent.get('https://tictail.com/apiv2/rpc/v1/?jsonrpc={"jsonrpc":"2.0", "method":"store.navigation.get.many", "params":{"store_id":' + store_id + '}, "id":null}').body
navigation = JSON.parse(navigation)
navigation = navigation["result"]

original_navigation = navigation.clone

subnav = navigation.select{ |item| item["parent_id"] != 0 }
navigation.select!{ |item| item["parent_id"] == 0 }

navigation.each do |item|
  item["children"] = []
  item["url"] = "/products/" << item["label"].to_url
  item["is_current"] = false
end

subnav.each do |subitem|
  parent = navigation.select { |item| item["id"] == subitem["parent_id"] }[0]
  parent["children"] << subitem
  parent["has_children"] = true
  subitem["url"] = parent["url"] + "/" + subitem["label"].to_url
  subitem["is_current"] = false
end

products = agent.get('https://tictail.com/apiv2/rpc/v1/?jsonrpc={"jsonrpc":"2.0","method":"store.product.search","params":{"store_id":' + store_id + ',"published":false,"limit":17,"offset":0,"order_by":"position","descending":false},"id":null}').body
products = JSON.parse(products)
products = products["result"]
products.each do |product|
  product_extra = agent.get('https://tictail.com/apiv2/rpc/v1/?jsonrpc={"jsonrpc":"2.0","method":"store.product.get","params":{"store_id":' + store_id + ',"slug":"'+ product["url"][9,1000] +'","published":false},"id":null}').body
  product_extra = JSON.parse(product_extra)
  product_extra = product_extra["result"]
  product["all_images"] = product_extra["images"]

  if (product["out_of_stock"] == 1)
    product["out_of_stock"] = true
    product["in_stock"] = false
  else
    product["out_of_stock"] = false
    product["in_stock"] = true
  end

  product["price_with_currency"] = product["price"].split(".")[0] + " <span class='currency currency_sek'>"+ store["currency"] + "</span>"

  product["primary_image"]["sizes"].each do |key, value|
    name = "url-" << key
    product["primary_image"][name] = value
  end
  product["primary_image"].delete("sizes")

  product["all_images"].each do |image|
    image["sizes"].each do |key, value|
      name = "url-" << key
      image[name] = value
    end
    image.delete("sizes")
  end
end

# json = '{ "logo": ' << logo << ', "description": ' << description << ', "navigation": ' << navigation << ', "products": ' << products << ' }'

store["logotype"] = logo
store["description"] = description
store["navigation"] = navigation
store["original_navigation"] = original_navigation
store["products"] = products

File.open("store.json","w") do |f|
  f.write(JSON.pretty_generate(store))
end

puts "Fetch successful! View your data in store.json"