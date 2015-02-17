#!/usr/bin/env ruby

class Registries::CrateAndBarrel < PublicRegistry
private
  def get_products(doc)
    doc.css('.jsItemRow:not(.emptyCategoryRow)')
  end

  def get_name(product)
    product.css('.itemTitle').text.strip
  end

  def get_sku(product)
    sku = product.css('.skuNum').text.strip.match(/SKU (\S+)/)[1]
    "c&b:#{sku}"
  end

  def get_url(product)
    href = product.css('.itemTitle a')[0]['href'].sub(/^\/?/, '')
    "http://www.crateandbarrel.com/#{href}"
  end

  def get_remaining(product)
    desired = product.css('td')[4].css('.itemHas').text.strip.to_i
    fulfilled = product.css('td')[5].css('.itemHas').text.strip.to_i
    desired - fulfilled
  end
end
