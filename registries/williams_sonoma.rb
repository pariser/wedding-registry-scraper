#!/usr/bin/env ruby

class Registries::WilliamsSonoma < Registry
private
  def get_products(doc)
    doc.css('table.registry-category-list tbody tr')
  end

  def get_name(product)
    product.css('.product-detail .product-info .title a').text.strip
  end

  def get_sku(product)
    sku = product.css('.product-detail .product-info .item-number').text.strip.match(/: (\d+)/)[1]
    "williams-sonoma:#{sku}"
  end

  def get_url(product)
    product.css('.product-detail .product-info .title a')[0]['href']
  end

  def get_remaining(product)
    desired = product.css('td.requested').text.strip.to_i
    still_needs = product.css('td.still-needs').text.strip.to_i
    still_needs
  end
end
