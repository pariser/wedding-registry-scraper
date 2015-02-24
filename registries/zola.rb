#!/usr/bin/env ruby

class Registries::Zola < PublicRegistry
private
  def get_products(doc)
    doc.css('#all-panel .product-tile')
  end

  def get_name(product)
    product.css('.single-product-name').text.strip
  end

  def get_sku(product)
    sku = product.css('.single-product')[0]['id']
    "zola:#{sku}"
  end

  def get_url(product)
    href = product.css('.content a')[0]['href'].sub(/^\/?/, '')
    "https://www.zola.com/#{href}"
  end

  def get_remaining(product)
    product.css('.needed').text.strip.gsub(/[^\d]+/, '').to_i
  end
end
