class WeddingRegistryScraper::Registries::BedBathBeyond < WeddingRegistryScraper::Registry
  @display_name = "Bed Bath & Beyond"
  @domain = "bedbathandbeyond.com"
private
  def get_products(doc)
    doc.css('.productRow')
  end

  def get_name(product)
    product.css('.productName').text.strip
  end

  def get_sku(product)
    sku = product.css('.productAttributes').children.last.text.strip
    "UPC:#{sku}"
  end

  def get_url(product)
    @url
  end

  def get_image_url(product)
    thumb_src = product.css('.productImage img')[0]['src']
  end

  def get_remaining(product)
    desired = product.css('.requested').text.strip.to_i
    fulfilled = product.css('.purchase').text.strip.to_i
    desired - fulfilled
  end

  def get_desired(product)
    product.css('.purchase').text.strip.to_i
  end

  def get_price(product)
      product.css('.rlpPrice').text.strip.gsub(/[^\d\.]/, '').to_f
  end

end
