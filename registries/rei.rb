#!/usr/bin/env ruby

class Registries::Rei < Registry
private
  def get_products(doc)
    doc.css('table.registryList').first.css('tr.tr0')
  end

  def get_name(product)
    product.css('a[name=prod]').text.strip
  end

  def get_sku(product)
    sku = get_url(product).match(/\/product\/(\d+)/)[1].to_i
    "rei-#{sku}"
  end

  def get_url(product)
    href = product.css('a[name=prod]')[0]['href'].sub(/^\/?/, '')
    "https://www.rei.com/#{href}"
  end

  def get_remaining(product)
    requested = product.css('td')[4].text.strip.to_i
    purchased = product.css('td')[5].text.strip.to_i
    requested - purchased
  end
end
