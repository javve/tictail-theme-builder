require 'bundler/setup'
require 'sinatra'
require 'mustache/sinatra'
require 'json'
require 'httparty'

class App < Sinatra::Base
  register Mustache::Sinatra

  require 'views/layout'

  set :mustache, {
    :views     => 'views/',
    :templates => 'templates/'
  }
  set :public_folder, File.dirname(__FILE__) + '/static'


  get '/' do
    json = File.read("store.json").force_encoding('UTF-8')
    @store = JSON.parse(json)
    @products = @store["products"]
    @on_index = true
    mustache :list_page
  end

  get '/about' do
    json = File.read("store.json").force_encoding('UTF-8')
    @store = JSON.parse(json)
    @products = @store["products"]
    mustache :about_page
  end

  get '/product/:permalink' do
    json = File.read("store.json").force_encoding('UTF-8')
    @store = JSON.parse(json)
    @product = @store["products"].select { |q| q["url"] == "/product/"+params[:permalink] }[0]
    mustache :product_page
  end

  get '/products/:category/:subcategory' do
    json = File.read("store.json").force_encoding('UTF-8')
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
    json = File.read("store.json").force_encoding('UTF-8')
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
    json = File.read("store.json").force_encoding('UTF-8')
    @store = JSON.parse(json)
    @products = @store["products"]
    mustache :list_page
  end

  get '/dashboard/store/jonnyaction/themes/preview/771/search' do
    #response = HTTParty.get('https://tictail.com/dashboard/store/jonnyaction/themes/preview/771/search?q=vin')
    #response.body
    '{"count": 1, "is_empty": false, "products": [{"pinterest_pin_it_button": "\n    <div class=\"tictail_social_button tictail_pinterest_button\">\n        <a href=\"http://pinterest.com/pin/create/button/?url=%2Fproduct%2Fvintage-bag&media=http%3A%2F%2Fdtvep25tfu0n1.cloudfront.net%2Fmedia%2Fresize%2Fproduct%2F1000%2F36119-ea09c57713a9429084f8195280449fa9.jpeg&description={{title}} via {{store_name}}. Click on the image to see more!\" class=\"pin-it-button\" count-layout=\"none\">\n            <img src=\"//assets.pinterest.com/images/PinExt.png\"\n                alt=\"Pin It\" border=\"0\"/>\n        <\/a>\n    <\/div>", "no_primary_image": false, "primary_image?": true, "out_of_stock": false, "modified_at": 1376132742, "all_images?": true, "is_quantity_unlimited": true, "slideshow-1000": "\n    {{#all_images?}}\n    <div class=\"tictail_slideshow loop\">\n        {{#all_images}}\n        <div class=\"slide image_slide\">\n            <a href=\"{{url-2000}}\" class=\"fullscreen fullscreen_image\"\n                    data-fullscreen-group=\"product-{{id}}-images\">\n                {{#is_primary}}\n                <img src=\"{{url-1000}}\" alt=\"{{title}}\" itemprop=\"image\"/>\n                {{/is_primary}}\n                {{^is_primary}}\n                <div class=\"image_placeholder\" data-src=\"{{url-1000}}\"><\/div>\n                {{/is_primary}}\n            <\/a>\n        <\/div>\n        {{/all_images}}\n    <\/div>\n    {{/all_images?}}", "id": 425657, "description": "<span>Braided eyewear strap in genuine&nbsp;leather.&nbsp;Keep track of your precious eyewear with style. It\'s a Bonocle favorite!<\/span>", "variations?": true, "variations_radio": false, "title": "Vintage bag", "slideshow-500": "\n    {{#all_images?}}\n    <div class=\"tictail_slideshow loop\">\n        {{#all_images}}\n        <div class=\"slide image_slide\">\n            <a href=\"{{url-2000}}\" class=\"fullscreen fullscreen_image\"\n                    data-fullscreen-group=\"product-{{id}}-images\">\n                {{#is_primary}}\n                <img src=\"{{url-500}}\" alt=\"{{title}}\" itemprop=\"image\"/>\n                {{/is_primary}}\n                {{^is_primary}}\n                <div class=\"image_placeholder\" data-src=\"{{url-500}}\"><\/div>\n                {{/is_primary}}\n            <\/a>\n        <\/div>\n        {{/all_images}}\n    <\/div>\n    {{/all_images?}}", "social_buttons": "\n    <div class=\"tictail_social_buttons\">\n        {{twitter_tweet_button}}\n        {{pinterest_pin_it_button}}\n        {{facebook_like_button}}\n    <\/div>", "price_without_currency": "329", "add_to_cart": "\n            function(inner) {\n                return \"{{#in_stock}}\n      <form action=\"{{base_url}}/cart/{{store_subdomain}}/add\"\n       method=\"post\" class=\"tictail_add_to_cart\">\n          <input type=\"hidden\" name=\"store_id\" value=\"{{store_id}}\">\n          <input type=\"hidden\" name=\"product_id\" value=\"{{id}}\"><input type=\"hidden\" name=\"variation_id\"\n              value=\"{{#variations}}{{id}}{{/variations}}\">\" + render(inner) + \"<\/form>{{/in_stock}}\";\n            }\n        ", "slideshow-50": "\n    {{#all_images?}}\n    <div class=\"tictail_slideshow loop\">\n        {{#all_images}}\n        <div class=\"slide image_slide\">\n            <a href=\"{{url-2000}}\" class=\"fullscreen fullscreen_image\"\n                    data-fullscreen-group=\"product-{{id}}-images\">\n                {{#is_primary}}\n                <img src=\"{{url-50}}\" alt=\"{{title}}\" itemprop=\"image\"/>\n                {{/is_primary}}\n                {{^is_primary}}\n                <div class=\"image_placeholder\" data-src=\"{{url-50}}\"><\/div>\n                {{/is_primary}}\n            <\/a>\n        <\/div>\n        {{/all_images}}\n    <\/div>\n    {{/all_images?}}", "add_to_cart_button": "\n            function(inner) {\n                return \"<button type=\"submit\" class=\"tictail_button tictail_add_to_cart_button\">\" + render(inner) + \"<\/button>\";\n            }\n        ", "quantity_sum": 0, "price": "329.00 SEK", "in_stock": true, "price_with_currency": "329 <span class=\"currency currency_sek\">SEK<\/span>", "facebook_like_button": "\n    <div class=\"tictail_social_button tictail_facebook_button\">\n        <div class=\"fb-like\" data-href=\"/product/vintage-bag\" data-send=\"false\"\n            data-layout=\"button_count\" data-width=\"90\"\n            data-show-faces=\"false\"><\/div>\n    <\/div>", "no_variations": false, "twitter_tweet_button": "\n    <div class=\"tictail_social_button tictail_twitter_button\">\n        <a href=\"https://twitter.com/share\" class=\"twitter-share-button\"\n            data-related=\"tictail\" data-lang=\"en\"\n            data-url=\"/product/vintage-bag\" data-text=\"Worth checking out! {{title}} sold by {{store_name}} via @tictail\" data-count=\"none\">Tweet<\/a>\n    <\/div>", "no_all_images": false, "primary_image": {"url-50": "//dtvep25tfu0n1.cloudfront.net/media/resize/product/50/36119-ea09c57713a9429084f8195280449fa9.jpeg", "url-300": "//dtvep25tfu0n1.cloudfront.net/i/product/300/0/36119-ea09c57713a9429084f8195280449fa9.jpeg", "is_primary": true, "url-2000": "//dtvep25tfu0n1.cloudfront.net/media/resize/product/2000/36119-ea09c57713a9429084f8195280449fa9.jpeg", "url-1000": "//dtvep25tfu0n1.cloudfront.net/media/resize/product/1000/36119-ea09c57713a9429084f8195280449fa9.jpeg", "position": 0, "url-100": "//dtvep25tfu0n1.cloudfront.net/media/resize/product/100/36119-ea09c57713a9429084f8195280449fa9.jpeg", "url-500": "//dtvep25tfu0n1.cloudfront.net/media/resize/product/500/36119-ea09c57713a9429084f8195280449fa9.jpeg"}, "url": "/product/vintage-bag", "absolute_url": "/product/vintage-bag", "variations": [{"label": null, "is_default": true, "in_stock": true, "out_of_stock": false, "position": 0, "identifier": "5Gw9", "id": 647591, "quantity": null}], "klarna": false, "slideshow-100": "\n    {{#all_images?}}\n    <div class=\"tictail_slideshow loop\">\n        {{#all_images}}\n        <div class=\"slide image_slide\">\n            <a href=\"{{url-2000}}\" class=\"fullscreen fullscreen_image\"\n                    data-fullscreen-group=\"product-{{id}}-images\">\n                {{#is_primary}}\n                <img src=\"{{url-100}}\" alt=\"{{title}}\" itemprop=\"image\"/>\n                {{/is_primary}}\n                {{^is_primary}}\n                <div class=\"image_placeholder\" data-src=\"{{url-100}}\"><\/div>\n                {{/is_primary}}\n            <\/a>\n        <\/div>\n        {{/all_images}}\n    <\/div>\n    {{/all_images?}}", "all_images": [{"url-50": "//dtvep25tfu0n1.cloudfront.net/media/resize/product/50/36119-ea09c57713a9429084f8195280449fa9.jpeg", "url-300": "//dtvep25tfu0n1.cloudfront.net/i/product/300/0/36119-ea09c57713a9429084f8195280449fa9.jpeg", "is_primary": true, "url-2000": "//dtvep25tfu0n1.cloudfront.net/media/resize/product/2000/36119-ea09c57713a9429084f8195280449fa9.jpeg", "url-1000": "//dtvep25tfu0n1.cloudfront.net/media/resize/product/1000/36119-ea09c57713a9429084f8195280449fa9.jpeg", "position": 0, "url-100": "//dtvep25tfu0n1.cloudfront.net/media/resize/product/100/36119-ea09c57713a9429084f8195280449fa9.jpeg", "url-500": "//dtvep25tfu0n1.cloudfront.net/media/resize/product/500/36119-ea09c57713a9429084f8195280449fa9.jpeg"}], "identifier": "4rK3", "variations_select": false, "slideshow-300": "\n    {{#all_images?}}\n    <div class=\"tictail_slideshow loop\">\n        {{#all_images}}\n        <div class=\"slide image_slide\">\n            <a href=\"{{url-2000}}\" class=\"fullscreen fullscreen_image\"\n                    data-fullscreen-group=\"product-{{id}}-images\">\n                {{#is_primary}}\n                <img src=\"{{url-300}}\" alt=\"{{title}}\" itemprop=\"image\"/>\n                {{/is_primary}}\n                {{^is_primary}}\n                <div class=\"image_placeholder\" data-src=\"{{url-300}}\"><\/div>\n                {{/is_primary}}\n            <\/a>\n        <\/div>\n        {{/all_images}}\n    <\/div>\n    {{/all_images?}}", "currency_code": "SEK", "slideshow-2000": "\n    {{#all_images?}}\n    <div class=\"tictail_slideshow loop\">\n        {{#all_images}}\n        <div class=\"slide image_slide\">\n            <a href=\"{{url-2000}}\" class=\"fullscreen fullscreen_image\"\n                    data-fullscreen-group=\"product-{{id}}-images\">\n                {{#is_primary}}\n                <img src=\"{{url-2000}}\" alt=\"{{title}}\" itemprop=\"image\"/>\n                {{/is_primary}}\n                {{^is_primary}}\n                <div class=\"image_placeholder\" data-src=\"{{url-2000}}\"><\/div>\n                {{/is_primary}}\n            <\/a>\n        <\/div>\n        {{/all_images}}\n    <\/div>\n    {{/all_images?}}"}], "products?": true, "no_products": false}'
  end
end
