require 'sinatra/base'
require 'mustache/sinatra'
require 'json'

class App < Sinatra::Base
  register Mustache::Sinatra


  require 'views/layout'

  set :mustache, {
    :views     => 'views/',
    :templates => 'templates/'
  }
  set :public_folder, File.dirname(__FILE__) + '/static'


  get '/' do
    json = File.read("lib/store.json").force_encoding('UTF-8')
    @store = JSON.parse(json)
    @products = @store["products"]
    mustache :list_page
  end

  get '/about' do
    json = File.read("lib/store.json").force_encoding('UTF-8')
    @store = JSON.parse(json)
    @products = @store["products"]
    mustache :about_page
  end

  get '/product/:permalink' do
    json = File.read("lib/store.json").force_encoding('UTF-8')
    @store = JSON.parse(json)
    @product = @store["products"].select { |q| q["url"] == "/product/"+params[:permalink] }[0]
    mustache :product_page
  end

  get '/products/:category/:subcategory' do
    json = File.read("lib/store.json").force_encoding('UTF-8')
    @store = JSON.parse(json)

    @category = @store["original_navigation"].select{ |n| n["url"] == '/products/'+params[:category] + '/' + params[:subcategory] }[0]
    @products = @store["products"].select{ |p| p["navigation_ids"].include? @category["id"] }
    @store["navigation"].each do |nav|
      if nav["url"] == '/products/'+params[:category]
        nav["is_current"] = true
        nav["children"].each do |subnav|
          if subnav["url"] == '/products/'+params[:category] + '/' + params[:subcategory]
            subnav["is_current"] = true
          end
        end
      end
    end
    mustache :list_page
  end

  get '/products/:category' do
    json = File.read("lib/store.json").force_encoding('UTF-8')
    @store = JSON.parse(json)
    @category = @store["original_navigation"].select{ |n| n["url"] == '/products/'+params[:category] }[0]
    @products = @store["products"].select{ |p| p["navigation_ids"].include? @category["id"] }
    @store["navigation"].each do |nav|
      if nav["url"] == '/products/'+params[:category]
        nav["is_current"] = true
      end
    end
    mustache :list_page
  end

  get '/products' do
    json = File.read("lib/store.json").force_encoding('UTF-8')
    @store = JSON.parse(json)
    @products = @store["products"]
    mustache :list_page
  end
end
