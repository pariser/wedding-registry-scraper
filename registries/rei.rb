#!/usr/bin/env ruby

require 'uri'

class Registries::Rei < Registry
  @display_name = "REI"
private
  def get_product_details_url(product)
    href = product.css('a[name=prod]')[0]['href'].sub(/^\/?/, '')
    "https://www.rei.com/#{href.sub(/^\//, '')}"
  end

  def get_products(doc)
    doc.css('table.registryList').first.css('tr.tr0')
  end

  def get_name(product)
    product.css('a[name=prod]').text.strip
  end

  def get_sku(product)
    sku = get_product_details_url(product).match(/\/product\/(\d+)/)[1].to_i
    "rei-#{sku}"
  end

  def get_url(product)
    @url
  end

  def get_image_url(product)
    details_url = get_product_details_url(product)

    puts "GET #{details_url.inspect}" if @debug
    result = Unirest.get(details_url)
    doc = Nokogiri::HTML(result.body)

    image_url = doc.css('#zoomLink')[0]['href']
    "https://www.rei.com/#{image_url.sub(/^\//,'')}"
  end

  def get_remaining(product)
    product.css('td')[5].text.strip.to_i
  end

  def get_desired(product)
    product.css('td')[4].text.strip.to_i
  end

  def get_price(product)
    product.css('td')[3].text.strip.sub('$','').to_f
  end
end
