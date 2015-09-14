class WeddingRegistryScraper::Registries::Rei < WeddingRegistryScraper::Registry
  @display_name = "REI"
  @domain = "rei.com"
private
  def get_product_details_url(product)
    link = product.css('a[name=prod]')
    return if link.empty?
    "https://www.rei.com/#{link[0]['href'].sub(/^\/?/, '')}"
  end

  def get_products(doc)
    doc.css('table.registryList').first.css('tr.tr0')
  end

  def get_name(product)
    product.css('td')[1].children.first.text.strip
  end

  def get_sku(product)
    sku = product.css('td')[1].children.last.text.strip
    "rei-#{sku}"
  end

  def get_url(product)
    @url
  end

  def get_image_url(product)
    details_url = get_product_details_url(product)
    return "" if details_url.blank?

    puts "GET #{details_url.inspect}" if @debug
    result = Unirest.get(details_url)
    doc = Nokogiri::HTML(result.body)

    if (obj = doc.css('#zoomLink')).present?
      image_url = obj[0]['href']
    elsif (obj = doc.css('#js-product-primary-img')).present?
      image_url = obj[0]['data-high-res-img']
    end

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
