require 'nokogiri'
require 'rss'
require 'open-uri'
require 'mediawiki_api'
url = 'https://commons.wikimedia.org/w/api.php?action=featuredfeed&feed=potd&feedformat=rss&language=it'
open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  @imageoftheday = feed.items.last
end
puts @imageoftheday
html_doc = Nokogiri::HTML(@imageoftheday.description)
didascalia = html_doc.css(".it").first.text
nomefile = html_doc.css("[decoding = async]").first['alt']

client = MediawikiApi::Client.new "https://it.wikipedia.org/w/api.php"
if !File.exist? '.wikiuser'
  puts 'Inserisci username:'
  puts '>'
  username = gets.chomp
  puts 'Inserisci password:'
  puts '>'
  password = gets.chomp
  File.open(".wikiuser", "w") do |file| 
    file.puts username
    file.puts password
  end
end
userdata = File.open(".wikiuser", "r").to_a
client.log_in "#{userdata[0]}", "#{userdata[1]}
client.edit title: "Utente:Ferdi2005/immaginedelgiorno", text: "[[File:#{nomefile}|#{didascalia}|200x200px|miniatura|center]]"