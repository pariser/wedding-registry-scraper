class WeddingRegistryScraper::Registries::PotteryBarn < WeddingRegistryScraper::Registry
  @display_name = "Pottery Barn"
  @domain = "potterybarn.com"
private
  def get_products(doc)
    doc.css('.regListItem')
  end

  def get_name(product)
    product.css('.product-name').text.strip
  end

  def get_sku(product)
    sku = product.css('.product-sku').text.strip
    "potterybarn:#{sku}"
  end

  def get_url(product)
    # TODO pop up modal? set proper anchor (they're not unique!)
    @url
  end

  def get_image_url(product)
    thumb_src = product.css('.product-image img')[0]['src']
    thumb_src.sub(/f\.jpg$/, 'c.jpg')
  end

  def get_remaining(product)
    product.css('.still-needs').text.strip.to_i
  end

  def get_desired(product)
    product.css('.requested').text.strip.to_i
  end

  def get_price(product)
    product.css('.product-price .price-amount').text.to_f
  end
end
