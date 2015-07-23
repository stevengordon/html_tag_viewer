class PagesController < ApplicationController
	# Use Nokogiri for website content loading and parsing
  require 'Nokogiri'
  require 'open-uri'

  def index
    @doc = Nokogiri::HTML(open("http://www.nytimes.com/"))
  
    @body = @doc.css('body')

    @brackets = @body.to_s.split("<")

    @tag_frequency_hash = Hash.new(0)

    @brackets.each do |t|
      if !(t=="" || t[0]=="/" || t[0]=="!")
        #get here for any bracket that starts a new tag
        t = t.split(" ")[0] #This returns the first word of the tag
        t = t.split(">")[0] #This returns the first part of first word, up to any ">"
        @tag_frequency_hash[t] += 1
      end
    end

    #byebug
  end
end
