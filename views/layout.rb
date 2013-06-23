class App
  module Views
    class Layout < Mustache

      def store
        @store
      end

      def lang
        @store
      end

      ######################################
      # Store Info
      ######################################

      def store_name
        @store["name"]
      end

      def store_url
        @store["url"]
      end

      def store_email
        @store["email"]
      end

      def store_description
        @store["description"]
      end

      def store_blog_url
        @store["blog_url"]
      end

      def store_subdomain
        @store["subdomain"]
      end

      def store_id
        @store["id"]
      end

      def logotype
        @store["logotype"]
      end

      ######################################
      # Navigation
      ######################################
      def navigation
        @store["navigation"]
      end

      def search
        '<form id="tictail_search" class="tictail_form tictail_search">'\
        '  <input id="tictail_search_box" name="q" autocomplete="off" type="text" title="Search" />'\
        '</form>'
      end

      def return_policy
        lambda do |text|
          "<a class='tictail_return-policy fullscreen fullscreen_iframe' href='/dashboard/store/jonnyaction/themes/preview/771/legal/return-policy'>"+text+"</a>"
        end
      end

      def terms
        lambda do |text|
          "<a class='tictail_terms fullscreen fullscreen_iframe' href='/dashboard/store/jonnyaction/themes/preview/771/legal/terms'>"+text+"</a>"
        end
      end

      ######################################
      # Payment info
      ######################################


      def payment_alternatives
        {
          type: "",
          logo: "",
          logo_bw: ""
        }
      end

      def klarna
        {
          eid: 0
        }
      end


      ######################################
      # Shipping info
      ######################################

      def shipping_destinations
        @store.shipping_destinations
      end


      ######################################
      # Social
      ######################################

      def facebook_like_button
        '<div class="tictail_social_button tictail_twitter_button">'\
        '    <a href="https://twitter.com/share" class="twitter-share-button"'\
        '        data-related="tictail" data-lang="en"'\
        '        data-url="http://jonnyaction.tictail.com/product/cool-shirt" data-text="Worth checking out! Cool shirt sold by Jonny Action via @tictail" data-count="none">Tweet</a>'\
        '</div>'
      end

      def twitter_tweet_button
        '<div class="tictail_social_button tictail_facebook_button">'\
        '    <div class="fb-like" data-href="http://jonnyaction.tictail.com/product/cool-shirt" data-send="false"'\
        '        data-layout="button_count" data-width="90"'\
        '        data-show-faces="false"></div>'\
        '</div>'\
      end

      def social_buttons
        '<div class="tictail_social_buttons">'\
        '  <div class="tictail_social_button tictail_twitter_button">'\
        '      <a href="https://twitter.com/share" class="twitter-share-button"'\
        '          data-related="tictail" data-lang="en"'\
        '          data-url="http://jonnyaction.tictail.com/product/cool-shirt" data-text="Worth checking out! Cool shirt sold by Jonny Action via @tictail" data-count="none">Tweet</a>'\
        '  </div>'\
        ''\
        '  <div class="tictail_social_button tictail_pinterest_button">'\
        '      <a href="http://pinterest.com/pin/create/button/?url=http%3A%2F%2Fjonnyaction.tictail.com%2Fproduct%2Fcool-shirt&media=http%3A%2F%2Fdmb7ixdwya1nh.cloudfront.net%2Fstore%2Fmedia%2Fi%2Fproduct%2F1000%2F0%2F36119-6c39583c592b46e49826148e4a1d0701.jpg&description=Cool shirt via Jonny Action. Click on the image to see more!" class="pin-it-button" count-layout="none">'\
        '          <img src="http://assets.pinterest.com/images/PinExt.png"'\
        '              alt="Pin It" border="0"/>'\
        '      </a>'\
        '  </div>'\
        ''\
        '  <div class="tictail_social_button tictail_facebook_button">'\
        '      <div class="fb-like" data-href="http://jonnyaction.tictail.com/product/cool-shirt" data-send="false"'\
        '          data-layout="button_count" data-width="90"'\
        '          data-show-faces="false"></div>'\
        '  </div>'\
        '</div>'
      end

      ######################################
      # Misc
      ######################################

      def assets_url
        "http://dhskp7m6mg2zv.cloudfront.net/theme_assets"
      end

      ######################################
      # List page
      ######################################

      def list_page
        {
          on_index: true,
          current_navigation: [],
          products: []
        }
      end
    end
  end
end