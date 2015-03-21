#!/usr/bin/env ruby

class WeddingRegistryScraper::Registries::WilliamsSonoma < WeddingRegistryScraper::Registry
  @display_name = "Williams-Sonoma"
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
    # product.css('.product-detail .product-info .title a')[0]['href']
    @url
  end

  def get_image_url(product)
    product.css('img')[0]['src'].sub(/f\.jpg$/, 'c.jpg')
  end

  def get_remaining(product)
    product.css('td.still-needs').text.strip.to_i
  end

  def get_desired(product)
    product.css('td.requested').text.strip.to_i
  end

  def get_price(product)
    if (sale_price = product.css('td.price .price-state.price-special')).any?
      sale_price.css('.currencyUSD .price-amount').text.strip.to_f
    else
      product.css('td.price .price-state.price-standard .currencyUSD .price-amount').text.strip.to_f
    end
  end
end
