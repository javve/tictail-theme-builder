# The unoffical Tictail Theme Builder for local developmet

We all love Tictail, right? But the ones of us how've built a store theme
knows that using the online editor sometimes could be a bit limiting. I'm
pretty sure that their team is working hard on solving this problem. But in
the meantime, maybe this project can help.

I was asked to build a official theme for Tictail and ended up spending most
of the time making this project instead.

### What is it?
This project basically enables you to build your theme locally on your own 
computer with your favorite editor, as you normally make websites.

With the CSS in one file and one file for each Mustache template. Great success!

```
# The important files:
lib/
static/
  dropkick.css
  style.css
templates/
  about_page.mustache
  layout.mustache
  list_page.mustache
  product_page.mustache
views/
```


### How it works?
Your Tictail data is downloaded to your local computer, then I've made a 
small Sinatra app that mimics the official Tictail stores with same routes,
templates, etc.

## Requirements 
* Ruby
* Bundler

### Usage

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

4. Spin up a server with [Rack](http://rack.rubyforge.org/doc/).
  ```
  $ rackup config.ru
  [2013-08-09 12:29:48] INFO  WEBrick 1.3.1
  [2013-08-09 12:29:48] INFO  ruby 1.9.3 (2012-02-16) [x86_64-darwin12.2.0]
  [2013-08-09 12:29:48] INFO  WEBrick::HTTPServer#start: pid=7101 port=9292
  ```
5. Build you theme by changing the files in `/templates`
6. When you are ready to test your theme at Tictail.com just write this command in the terminal:
  
  ```
  $ ruby lib/printer.rb
  ```
  *Your theme is now saved to both you __clipboad__ and to __theme.mustache__*.  
  Great success! Just paste it into the Tictail.com-editor


### Warning
I've implemented many (the ones I needed for my own template), but not all of the tags in the [Tictail documentation](https://tictail.com/docs/templates).
Feel free to contribute.

As stated above, this is an unofficial project. I can't say how long it will work or promis that it'll stay
up to date with Tictail.

All backend code is really, really ugly. Yes, I mean, really ugly. But it get's the job done, hehe ;)

### Things that differ in the local development vs Tictail.com
These are converted by `lib/printer.rb`.
```
{{search}} --> {{{serach}}}
{{social_buttons}} --> {{{social_buttons}}}
{{price_with_currency}} --> {{{price_with_currency}}}
{{children?}}{{/children}} --> {{#has_children?}}{{/has_children}}
{{store_description}}--> {{{store_description}}}
{{description}}--> {{{description}}}
```
