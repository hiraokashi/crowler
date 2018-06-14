#!/usr/bin/env ruby
#
#
require 'nokogiri'
require 'open-uri'
require 'csv'
urls = (1..49).map {|p| "https://www.doorkeeper.jp/groups?page=#{p}"}
communities = []

charset = nil
urls.each do |url|
  p url
  html = open(url) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)
  doc.xpath('//div[@class="group-card"]').each do |node|
    title = node.css('.group-card-name').inner_text
    category = node.css('.list-inline').inner_text.gsub(/(\r\n|\r|\n)/, " ")
    link = node.css('.group-card-name/a').attribute("href")
    communities.push([title, category, link])
  end
end

CSV.open("door_title.csv", "w",col_sep: "\t") do |csv|
  communities.each { |r| csv << r }
end
