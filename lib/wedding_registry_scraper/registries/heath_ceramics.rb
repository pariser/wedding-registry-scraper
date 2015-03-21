require 'uri'

ActiveSupport::Inflector.inflections(:en) do |inflector|
  inflector.uncountable 'heath_ceramics'
end

class WeddingRegistryScraper::Registries::HeathCeramics < WeddingRegistryScraper::Registry
  @display_name = "Heath Ceramics"
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

  def get_image_url(product)
    details_url = product.css('[data-url]')[0]['data-url']

    request_params = {
      :headers => {
        'X-Requested-With' => 'XMLHttpRequest'
      }
    }

    result = with_lax_heath_uri_parsing do
      puts "GET #{details_url.inspect} with params #{request_params.to_json}" if @debug
      Unirest.get(details_url, request_params)
    end

    doc = Nokogiri::HTML(result.body)

    if doc.css('ul.mixMatchList').any?
      doc.css('ul.mixMatchList li:last-child img[src]')[0]['src']
    else
      doc.css('.imagesScrollable img[src]')[0]['src']
    end
  end

  def get_remaining(product)
    fulfillment = product.css('.fulfilled').text.strip
    fulfillment.match(/^(\d+)/)[0].to_i
  end

  def get_desired(product)
    fulfillment = product.css('.fulfilled').text.strip
    fulfillment.match(/(\d+)$/)[0].to_i
  end

  def get_price(product)
      product.css('.price').text.strip.gsub(/[^\d\.]/, '').to_f
  end

  def with_lax_heath_uri_parsing(&block)
    URI::RFC3986_Parser.class_eval do
      alias_method :old_split, :split

      def split(uri)
        # scheme, userinfo, host, port, registry, path, opaque, query, fragment
        [ "http", nil, "www.heathceramics.com", nil, nil, uri.sub(/^https?:\/\/www.heathceramics.com/, ''), nil, nil, nil ]
      end
    end

    exception = nil
    begin
      result = yield
    rescue Exception => e
      exception = e
    ensure
      URI::RFC3986_Parser.class_eval do
        alias_method :split, :old_split
      end
    end

    raise exception if exception
    result
  end
end
