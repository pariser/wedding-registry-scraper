#!/usr/bin/env ruby

class WeddingRegistryScraper::Registries::Zola < WeddingRegistryScraper::Registry
  @display_name = "Zola"
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

  def get_image_url(product)
    product.css('[data-image-url]')[0]['data-image-url']
  end

  def get_remaining(product)
    product.css('.needed').text.strip.gsub(/[^\d]+/, '').to_i
  end

  def get_desired(product)
  end

  def get_price(product)
    product.css('[data-price]')[0]['data-price'].gsub(/[$,]/, '').to_f
  end

  def price_type(product)
    product_price = product.css('.product-price')

    if product_price.length > 0 && product_price[0].text.strip == 'Contribute what you wish'
      WeddingRegistryScraper::Registry::VARIABLE_PRICE
    else
      WeddingRegistryScraper::Registry::FIXED_PRICE
    end
  end

  def fulfilled?(product)
    if price_type(product) == WeddingRegistryScraper::Registry::VARIABLE_PRICE
      get_price(product) <= 0
    else
      get_remaining(product) <= 0
    end
  end
end
