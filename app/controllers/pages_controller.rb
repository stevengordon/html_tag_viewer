class PagesController < ApplicationController
	# Use Nokogiri for website content loading and parsing
  require 'Nokogiri'
  require 'open-uri'

  def index

    @which_page = @which_page || ""

    #which_url = "http://"+params[:site]

    @which_url = params[:site] || "http://www.nytimes.com/"

    @doc = Nokogiri::HTML(open(@which_url))
  
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
