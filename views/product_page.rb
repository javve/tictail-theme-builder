class App
  module Views
    class ProductPage < Layout
      def product
        @product['slideshow-500'] = slideshow(500)
        @product
      end
      def product_page
        true
      end

      def add_to_cart
        @product["in_stock"]
      end

      def variations_select
        lambda do |text|
          html = ""
          if @product["variations"]
            html += '<select name="variation_id" class="tictail_select tictail_variations_select">'
            @product["variations"].each do |variation|
              if variation["label"] != nil
                html += '<option value="' + variation["id"].to_s + '">' + variation["label"] + '</option>'
              else
                return ""
              end
            end
            html += '</select>'
            html
          end
        end
      end

      def add_to_cart_button(lang)
        '<button type="submit" class="tictail_button tictail_add_to_cart_button">' + lang + '</button>'
      end

      def slideshow(size)
        lambda do |text|
          html = '<div class="tictail_slideshow loop">'
            @product["all_images"].each do |image|
              html += '<div class="slide image_slide">'
              html += ' <a href="'+image["url-2000"]+'" class="fullscreen fullscreen_image" data-fullscreen-group="product-273314-images">'
              html += '   <img src="'+image["url-2000"]+'" alt="Cool shirt" itemprop="image"/>'
              html += ' </a>'
              html += '</div>'
            end
          html += '</div>'
          html
        end
      end
    end
  end
end
