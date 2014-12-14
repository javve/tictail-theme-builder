# BANANABAD CODE.
# You have been warned.

require 'rubygems'
require 'mechanize'
require 'json'
require 'stringex'
require './lib/tictail_api'

if (ARGV.length > 3 || ARGV.length < 2)
  puts "Script usage: ruby lib/fetcer.rb <tictail-email> <tictail-password> <tictail-storename>"
  puts "<tictail-storename> is optional and if used should be written lowercased without spaces, like mysuperawesomestore"
  exit
end

class Fetcher
  attr_accessor :store_id, :agent, :api, :store, :logo, :description, :navigation, :original_navigation

  def initialize(email, password, storeName={})
    @agent = Mechanize.new

    page = sign_in(email, password)
    if (page.title() == "Tictail - Log in")
      puts "Error. Could not log in. Wrong email or password? <3"
      exit
    end
    @store_id = get_store_id(page, storeName)
    @store = get_store_data(page, storeName)

    @api = Tictail_api.new(@agent, @store_id)

    @logo = logo()
    @description = description()
    navigation()
    @products = products()

    @store["logotype"] = @logo
    @store["description"] = @description
    @store["navigation"] = @navigation
    @store["original_navigation"] = @original_navigation
    @store["products"] = @products

    save();
  end

  def sign_in(email, password)
    page = @agent.get('https://tictail.com/user/signin')

    sign_in_form = page.form()
    sign_in_form.email = email
    sign_in_form.passwd = password

    @agent.submit(sign_in_form, sign_in_form.buttons.first)
  end

  def get_store_id(page, storeName)
    get_store_data(page, storeName)["id"]
  end

  def get_store_data(page, storeName)
    login = Hash.new
    stores = page.body.scan(/var ClientSession = (.*);\n/)[0][0]
    stores = JSON.parse(stores)
    stores = stores["storekeeper"]["stores"]

    login["stores"] = stores

    if storeName.nil?
      store = stores.first[1]
    else
      store = login["stores"][storeName]
    end

    store["url"] = "/"
    store
  end

  def logo
    logo = @api.get("store.media.logotype.get")["logotype"]
    if logo
      logo["sizes"].each do |key, value|
        name = "url-" << key
        logo[name] = value
      end
      logo.delete("sizes")
      logo
    end
  end

  def description
    description = @api.get("store.description.get")["description"]
    description
  end

  def navigation
    @navigation = @api.get("store.navigation.get.many")
    @original_navigation = @navigation.clone

    subnav = get_subnav()
    remove_subnavigation_from_main()
    fix_navigation_attributes()
    fix_subnav_and_nav_structure(subnav)
  end

  def get_subnav
    @navigation.select{ |item| item["parent_id"] != 0 }
  end

  def remove_subnavigation_from_main
    @navigation.select!{ |item| item["parent_id"] == 0 }
  end

  def fix_navigation_attributes
    @navigation.each do |item|
      item["children"] = []
      item["url"] = "/products/" << item["label"].to_url
      item["is_current"] = false
    end
  end

  def fix_subnav_and_nav_structure(subnav)
    subnav.each do |subitem|
      parent = @navigation.select { |item| item["id"] == subitem["parent_id"] }[0]
      parent["children"] << subitem
      parent["has_children"] = true
      subitem["url"] = parent["url"] + "/" + subitem["label"].to_url
      subitem["is_current"] = false
    end
  end

  def products
    products = @api.get_full('{"jsonrpc":"2.0","method":"store.product.search","params":{"store_id":' + store_id.to_s + ',"published":false,"limit":17,"offset":0,"order_by":"position","descending":false},"id":null}')
    products.each do |product|
      product_extra = @api.get_full('{"jsonrpc":"2.0","method":"store.product.get","params":{"store_id":' + store_id.to_s + ',"slug":"'+ product["url"][9,1000] +'","published":false},"id":null}')
      product["all_images"] = product_extra["images"]

      product = fix_stock(product)
      product["price_with_currency"] = product["price"].split(".")[0] + " <span class='currency currency_sek'>"+ @store["currency"] + "</span>"

      if product.has_key?("primary_image")
        product["primary_image"]["sizes"].each do |key, value|
          name = "url-" << key
          product["primary_image"][name] = value
        end
        product["primary_image"].delete("sizes")
      end
      
      unless product["all_images"].nil?
        product["all_images"].each do |image|
          image["sizes"].each do |key, value|
            name = "url-" << key
            image[name] = value
          end
          image.delete("sizes")
        end
      end
    end
    products
  end

  def fix_stock(product)
    if (product["out_of_stock"] == 1)
      product["out_of_stock"] = true
      product["in_stock"] = false
    else
      product["out_of_stock"] = false
      product["in_stock"] = true
    end
    product
  end

  def save
    File.open("store.json","w") do |f|
      f.write(JSON.pretty_generate(@store))
    end
    puts "Fetch successful! View your data in store.json"
  end
end

Fetcher.new(ARGV[0], ARGV[1], ARGV[2])
