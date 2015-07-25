class PagesController < ApplicationController
	# Use Nokogiri for website HTML loading
  # require 'nokogiri'
  # require 'open-uri'

  def index
    # This method displays the form on which user can enter the URL to fetch
    @error = "" # Start without any error message
  end

  def show
    # This method prepares the information to display the HTML and tags
    # Class variables are used in order to pass information between this show method and the change_tag method, without re-scraping original site

    # Get the URL as parameter from user form
    @@which_url = params[:page][:fetch_url] || @@which_url # This is the URL that user entered on form

    # Call method to load HTML from selected URL
    load_html(@@which_url)

    # Call method to count tags within fetched HTML
    count_tags()

    # Initially highlight the most frequently used tag
    @@highlight_tag = @@tag_frequency_sorted.first[0]

    # Create instance variables to pass to shared view (shared by this method and change_tag method)
    @which_url = @@which_url
    @tag_frequency_sorted = @@tag_frequency_sorted
    @body_text = @@body_text
    @highlight_tag = @@highlight_tag
  end

  def change_tag
    # This method changes the highlighted tag and reloads the "show" page -- but without reloading the full HTML from the source site

    # Get the clicked-on tag from the URL parameter
    @@highlight_tag = params[:tag]

    # Create instance variables to pass to shared view (shared by this method and show method)
    @which_url = @@which_url
    @tag_frequency_sorted = @@tag_frequency_sorted
    @body_text = @@body_text
    @highlight_tag = @@highlight_tag

    render "show" # Render the show view but with a different highlight tag selected
  end

  private 

  def load_html(url)
    # This method loads the HTML from the source site
    # It saves the HTML as a string into a class variable @@body_text

    @@error = "" # Reset any prior error message

    html_doc = Nokogiri::HTML(open(@@which_url)) # Load HTML with Nokogiri gem
    body = html_doc.css('body')
    brackets = body.to_s.split("<") # This is set of all tags, each starting with a "<"
    @@body_text = body.to_s # This is the string version of the scrapted HTML body

  rescue
    # Get here if the HTML did not load properly
    puts "The entered URL of "+@@which_url+" did not work"
    @error = "The URL you entered of "+@@which_url+" was not valid. Please try again."
    render "index" # Return to URL entry page; don't try to display empty HTML
  end
  
  def count_tags
    # This method parses HTML as text to identify and count the frequency of each tag
    # The input is the shared variable @@body_text
    # The output is the shared variable @@tag_frequency_sorted

    brackets = @@body_text.split("<") # This is set of all tags, each starting with a "<"

    # Count the frequency of each tag
    tag_frequency = Hash.new(0)
    brackets.each do |t|
      if !(t[0]=="/" || t[0]=="!" || t=="") # Eliminate closing tags, comments and empty tags
        # Get here for any bracket that starts a new tag
        t = t.split(" ")[0] # This returns the first word of the tag
        t = t.split(">")[0] # This returns the first part of first word, up to any ">"
        tag_frequency[t] += 1
      end
    end

    # Sort tag hash to show most frequently used tags at top of list
    @@tag_frequency_sorted = tag_frequency.sort_by {|tag, frequency| frequency}.reverse.to_hash
  end

end