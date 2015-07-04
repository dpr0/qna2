require 'open-uri'
require 'nokogiri'
require 'json'

# url = 'http://www.cubecinema.com/programme'
url = 'http://localhost:3000/lens_lists'
html = open(url)

doc = Nokogiri::HTML(html)
showings = []
doc.css('.showing').each do |showing|
  showing_id = showing['id'].split('_').last.to_i
  tags = showing.css('.tags a').map { |tag| tag.text.strip }
  title_el = showing.at_css('h1 a')
  title_el.children.each { |c| c.remove if c.name == 'span' }
  title = title_el.text.strip
  dates = showing.at_css('.start_and_pricing').inner_html.strip
  dates = dates.split('<br>').map(&:strip).map { |d| DateTime.parse(d) }
  description = showing.at_css('.copy').text.gsub('[more...]', '').strip
  showings.push(id: showing_id, name: title, frmin: tags, frmax: dates, diafmin: description)
end
puts showings
# puts JSON.pretty_generate(showings)
