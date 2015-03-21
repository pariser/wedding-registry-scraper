require 'unirest'
require 'nokogiri'

class WeddingRegistryScraper::Registry
  PRICE_TYPES = [
    FIXED_PRICE = 'Fixed price',
    VARIABLE_PRICE = 'Variable price',
  ]

  class << self
    attr_reader :display_name
  end

  def initialize(url, params={})
    params.symbolize_keys!
    @url = url
    @debug = params[:debug] == true
  end

  def get_items
    doc = get_registry

    get_products(doc).reduce({}) do |products, product|
      sku = get_sku(product)

      details = {
        :name => get_name(product),
        :remaining => get_remaining(product),
        :desired => get_desired(product),
        :url => get_url(product),
        :image_url => get_image_url(product),
        :registry_name => self.class.display_name,
        :fulfilled => fulfilled?(product),
        :price_type => price_type(product),
        :price_value => get_price(product),
      }

      products.merge! sku => details
    end
  end

private

  def get_products(doc)      ; raise NotImplementedError; end

  def get_name(product)      ; raise NotImplementedError; end
  def get_sku(product)       ; raise NotImplementedError; end
  def get_url(product)       ; raise NotImplementedError; end
  def get_image_url(product) ; raise NotImplementedError; end
  def get_remaining(product) ; raise NotImplementedError; end
  def get_desired(product)   ; raise NotImplementedError; end
  def get_price(product)     ; raise NotImplementedError; end

  def price_type(product)
    FIXED_PRICE
  end

  def fulfilled?(product)
    get_remaining(product) == 0
  end

  def get_registry
    result, _ = make_request(:get, @url)
    Nokogiri::HTML(result.body)
  end

  def make_request(method, url, params={})
    json = params.delete(:json)
    request_params = {}

    if cookies = params.delete(:cookies)
      request_params[:headers] = {
        'Cookie' => dump_cookies(cookies)
      }
    end

    if json
      request_params[:headers] = {
        'Accept' => "application/json"
      }
    end

    request_params[:parameters] = json ? params.to_json : params

    puts "#{method.to_s.upcase} #{url} with params #{request_params.to_json}" if @debug
    result = Unirest.send(method, url, request_params)

    puts "RESULT #{result.code} with headers #{result.headers.inspect}" if @debug

    open_result_in_browser(result) if @debug

    cookies = load_cookies(result.headers[:set_cookie])

    [ result, cookies ]
  end

  def open_result_in_browser(result)
    file = Tempfile.new(['weddding-scraper','.html'])
    file << result.body
    file.close

    `open "#{file.path}"`

    sleep 1
    file.unlink
  end

  def dump_cookies(cookies)
    cookies.map { |k, v| "#{k}=#{v}" }.join("; ")
  end

  def load_cookies(set_cookie)
    set_cookie ||= []
    set_cookie.reduce({}) do |cookies, cookie|
      key, value = cookie.split(';')[0].split('=')
      cookies.merge!(key => value || "")
    end
  end
end
