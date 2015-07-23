class PagesController < ApplicationController
	# Use Nokogiri for website content loading and parsing
  require 'Nokogiri'
  require 'open-uri'

  def index

    @which_page = @which_page || ""

    @which_url = params[:site] || "http://www.nytimes.com/"

    @html_doc = Nokogiri::HTML(open(@which_url))
  
    @body = @html_doc.css('body')

    @brackets = @body.to_s.split("<")

    @tag_frequency = Hash.new(0)

    @brackets.each do |t|
      if !(t[0]=="/" || t[0]=="!" || t=="") # Eliminate closing tags, comments and empty tags
        # Get here for any bracket that starts a new tag
        t = t.split(" ")[0] # This returns the first word of the tag
        t = t.split(">")[0] # This returns the first part of first word, up to any ">"
        @tag_frequency[t] += 1
      end
    end

    @tag_frequency_sorted = @tag_frequency.sort_by {|tag, frequency| frequency}.reverse.to_h

    @body_text = @body.to_s

    @test_text = "Hello World! The 'quick brown fox' jumped '<fox>'' over the <lazy dog>. The mean fox had went to Foxy's for dinner and found a foxy fox to eat."
    @test_text2 = "Hello <World>! The 'quick brown fox' jumped '<fox>'' over the <lazy dog>. The mean fox had went to Foxy's for dinner and found a foxy fox to eat."

   # @clean_text = ActionView::Base.full_sanitizer.sanitize(@test_text)

    #byebug
  end
end
