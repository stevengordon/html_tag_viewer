class PagesController < ApplicationController
	# Use Nokogiri for website HTML loading
  require 'Nokogiri'
  require 'open-uri'

  def index
    # This method displays the form on which user can enter the URL to fetch
  end

  def show
    # This method loads the HTML from the source site
    # Then parses HTML to identify and count the frequency of each tag
    # Class variables are used in order to pass information between this show method and the change_tag method, without re-scraping original site

    # Load and parse source HTML
    @@which_url = params[:page][:fetch_url] || @@which_url # This is the URL that user entered on form
    html_doc = Nokogiri::HTML(open(@@which_url)) # Load HTML with Nokogiri gem
    body = html_doc.css('body')
    brackets = body.to_s.split("<") # This is set of all tags, each starting with a "<"
    @@body_text = body.to_s # This is the string version of the scrapted HTML body

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
    @@tag_frequency_sorted = tag_frequency.sort_by {|tag, frequency| frequency}.reverse.to_h

    # Initially highlight the most frequently used tag
    @@highlight_tag = @@tag_frequency_sorted.first[0]

    # Create instance variables to pass to shared view (shared by this method and change_tag method)
    @which_url = @@which_url
    @tag_frequency_sorted = @@tag_frequency_sorted
    @body_text = @@body_text
    @highlight_tag = @@highlight_tag
  end

  def change_tag
    # This method changes the highlighted tag and reloads the page -- but without reloading the full HTML from the source site

    # Get the clicked-on tag from the URL parameter
    @@highlight_tag = params[:tag]

    # Create instance variables to pass to shared view (shared by this method and show method)
    @which_url = @@which_url
    @tag_frequency_sorted = @@tag_frequency_sorted
    @body_text = @@body_text
    @highlight_tag = @@highlight_tag

    render "show" # Render the show view but with a different highlight tag selected
  end
end
