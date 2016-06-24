class WeddingRegistryScraper::Registries::BedBathBeyond < WeddingRegistryScraper::Registry
  @display_name = "Bed Bath & Beyond"
  @domain = "bedbathandbeyond.com"
private
  def get_registry
    registry_id = CGI.parse(@url)["registryId"].first
    params = {
      registryId: registry_id,
      startIdx: 0,
      isGiftGiver: true,
      blkSize: 1000,
      isAvailForWebPurchaseFlag: false,
      # userToken: "UT1021",
      sortSeq: 1,
      view: 1,
      eventTypeCode: "BRD",
      eventType: "BRD",
      pwsurl: "",
      totalToCopy: 11,
      regAddress: "", # "27620 SUSAN BETH WAY\nUNIT E",
      eventDate: "", # "12/13/2014",
    }

    result, _ = make_request(:post, "http://www.bedbathandbeyond.com/store/giftregistry/frags/registry_items_guest.jsp", params)
    Nokogiri::HTML(result.body)
  end

  def get_products(doc)
    doc.css('.productRow')
  end

  def get_name(product)
    product.css('.productName .blueName').text.strip
  end

  def get_sku(product)
    sku = product.css('.productAttributes').first.css('dd').last.text.strip
    "UPC:#{sku}"
  end

  def get_url(product)
    @url
  end

  def get_image_url(product)
    product.css('.productImage img')[0].attributes["data-original"].value
  end

  def get_remaining(product)
    desired = get_desired(product)
    fulfilled = product.css('.purchase').children.last.text.strip.to_i
    desired - fulfilled
  end

  def get_desired(product)
    product.css('.requested').children.last.text.strip.to_i
  end

  def get_price(product)
    product.css('.rlpPrice').text.strip.gsub(/[^\d\.]/, '').to_f
  end
end
