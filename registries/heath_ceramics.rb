#!/usr/bin/env ruby

ActiveSupport::Inflector.inflections(:en) do |inflector|
  inflector.uncountable 'heath_ceramics'
end

class Registries::HeathCeramics < PublicRegistry
private
  def get_products(doc)
    doc.css('table#shopping-cart-table tbody tr')
  end

  def get_name(product)
    product.css('.attentionText').text.strip
  end

  def get_sku(product)
    text = product.css('.ctxProductCol .tinyText').map(&:text).detect { |t| t =~ /SKU/ }
    sku = text.match(/SKU:\s+(\S+)/)[1]
    "heath:#{sku}"
  end

  def get_url(product)
    @url
  end

  def get_remaining(product)
    fulfillment = product.css('.fulfilled').text.strip
    fulfillment.match(/^(\d+)/)[0].to_i
  end
end
