# The unoffical Tictail Theme Builder for local developmet

We all love Tictail, right? But the ones of us how've built a store theme
knows that using the online editor sometimes could be a bit limiting.


## Requirements 
* Ruby
* Bundler

## Usage

1. [Downlod this project](http://lol)
2. Open the terminal, go to the project and install dependencies.
  ```
  $ cd tictail-theme-builder
  $ bundle
  ```

3. Fetch your Tictail store data into `store.json` by this command:
  ```
  $ ruby lib/fetcher.rb <email> <password>
  
  # ex: ruby lib/fetcher javve@coolemail.com supersecret
  ```

4. Spin up a server with [Rack](http://rack.rubyforge.org/doc/) support (ex. WEBrick (installed with Ruby) or [Pow](http://pow.cx/)).
5. Build you theme by changing the files in `/templates`
6. When you are ready to test your theme at Tictail.com just write this command in the terminal:
  
  ```
  $ ruby lib/printer.rb
  ```
  *Your theme is then saved to both you __clipboad__ and to __theme.mustache__*


## Things that differ in the local development vs Tictail.com
```
{{search}} --> {{{serach}}}
{{social_buttons}} --> {{{social_buttons}}}
{{price_with_currency}} --> {{{price_with_currency}}}
{{children?}}{{/children}} --> {{#has_children?}}{{/has_children}}
{{store_description}}--> {{{store_description}}}
{{description}}--> {{{description}}}
```
