require 'Nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    index_page = Nokogiri::HTML(html)

    index_array = []

    index_page.css("div.student-card").each do |student|
      index_array << {
        name: student.css("a div.card-text-container h4.student-name").text,
        location: student.css("a div.card-text-container p.student-location").text,
        profile_url: student.css("a").attribute("href").value
      }
    end

    index_array
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profile_page = Nokogiri::HTML(html)

    profile_hash = {}

    links = profile_page.css("div.social-icon-container").children.css("a").map {|social| social.attribute("href").value}
    links.each do |link|
      if link.include?("twitter")
        profile_hash[:twitter] = link
      elsif link.include?("github")
        profile_hash[:github] = link
      elsif link.include?("linkedin")
        profile_hash[:linkedin] = link
      else
        profile_hash[:blog] = link
      end
    end   

    profile_hash[:profile_quote] = profile_page.css("div.profile-quote").text
    profile_hash[:bio] = profile_page.css("div.bio-content div.description-holder p").text

    profile_hash
  end

end

Scraper.scrape_index_page('fixtures/student-site/index.html')
Scraper.scrape_profile_page('fixtures/student-site/students/ryan-johnson.html')
# name: index_page.css("div.student-card a div.card-text-container h4.student-name").text
# location: index_page.css("div.student-card a div.card-text-container p.student-location").text
# profile_url: index_page.css("div.student-card a").attribute("href").value
