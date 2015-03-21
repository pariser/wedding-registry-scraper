class WeddingRegistryScraper::Registries::CrateAndBarrel < WeddingRegistryScraper::Registry
  @display_name = "Crate & Barrel"
  @domain = "crateandbarrel.com"
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
    # TODO pop up modal? set proper anchor (they're not unique!)
    @url
  end

  def get_image_url(product)
    thumb_src = product.css('img')[0]['src']
    thumb_src.sub(/\$web_itembasket\$/, '&$web_popup_zoom$&wid=379&hei=379')
  end

  def get_remaining(product)
    desired = product.css('td')[4].css('.itemHas').text.strip.to_i
    fulfilled = product.css('td')[5].css('.itemHas').text.strip.to_i
    desired - fulfilled
  end

  def get_desired(product)
    product.css('td')[4].css('.itemHas').text.strip.to_i
  end

  def get_price(product)
    if (sale_price = product.css('.salePrice')).any?
      /\$?(\d+(\.\d+)?)/.match(sale_price.text) { |match| match[1].to_f }
    elsif (regular_price = product.css('.regPrice')).any?
      /\$?(\d+(\.\d+)?)/.match(regular_price.text) { |match| match[1].to_f }
    end
  end
end
