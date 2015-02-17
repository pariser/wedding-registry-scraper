require 'unirest'
require 'nokogiri'
require 'colored'
require 'pp'
require 'active_support/core_ext/hash'

class AuthenticationFailed < StandardError; end

class Registry
  def initialize(params={})
    params.symbolize_keys!
    @debug = params[:debug] == true
  end

  def get_items
    doc = get_registry

    get_products(doc).reduce({}) do |products, product|
      sku = get_sku(product)

      details = {
        :name => get_name(product),
        :remaining => get_remaining(product),
        :url => get_url(product),
      }

      products.merge! sku => details
    end
  end

private

  def get_products(doc)      ; raise NotImplementedError; end

  def get_name(product)      ; raise NotEmplementedError; end
  def get_sku(product)       ; raise NotEmplementedError; end
  def get_url(product)       ; raise NotEmplementedError; end
  def get_remaining(product) ; raise NotEmplementedError; end

  def set_variables_on_initialize(required, optional, provided)
    required.each do |param|
      ivar = instance_variable_set("@#{param}", provided.delete(param))
      raise TypeError, "Required param: #{param}" if ivar.nil? || ivar.empty?
    end

    optional.each do |param|
      instance_variable_set("@#{param}", provided.delete(param)) if provided.has_key?(param)
    end
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

# ----------------------------

class PublicRegistry < Registry
  REQUIRED_PARAMS = [
    :url,
  ]

  OPTIONAL_PARAMS = []

  (REQUIRED_PARAMS + OPTIONAL_PARAMS).each do |param|
    attr_reader param
  end

  def initialize(params={})
    params.symbolize_keys!
    set_variables_on_initialize(REQUIRED_PARAMS, OPTIONAL_PARAMS, params)
    super(params)
  end

  def get_registry
    result, _ = make_request(:get, @url)
    Nokogiri::HTML(result.body)
  end
end

# ----------------------------

class PrivateRegistry < Registry
  class << self
    # Required class instance variables
    attr_accessor :login_url
    attr_accessor :login_cookies
    attr_accessor :login_json
  end

  REQUIRED_PARAMS = [
    :url,
    :login_params,
  ]

  OPTIONAL_PARAMS = [
    :cookies,
    :json,
  ]

  (REQUIRED_PARAMS + OPTIONAL_PARAMS).each do |param|
    attr_reader param
  end

  def initialize(params={})
    params.symbolize_keys!
    set_variables_on_initialize(REQUIRED_PARAMS, OPTIONAL_PARAMS, params)
    super(params)
  end

  def authenticated?(doc)
    raise NotImplementedError
  end

  def get_registry
    get_authenticated_registry(true)
  end

  def get_authenticated_registry(should_retry=true)
    if @cookies.nil? || @cookies.empty?
      should_retry = false

      puts "* Attempting login to #{self.class.name.demodulize}"
      login!
    end

    result, _ = make_request(:get, @url, :cookies => @cookies)

    doc = Nokogiri::HTML(result.body)
    authenticated = authenticated?(doc)
    puts (authenticated ? "Authenticated!" : "NOT Authenticated!").yellow if @debug

    if !authenticated && should_retry
      puts "* Retrying login to #{@name}"
      login!

      result, _ = make_request(:get, @url, :cookies => @cookie)
      doc = Nokogiri::HTML(result.body)
      authenticated = authenticated?(doc)
    end

    raise AuthenticationFailed if !authenticated

    doc
  end

  def login!
    result, cookies = make_request(:post, self.class.login_url, @login_params.merge(:json => self.class.login_json))

    login_cookies = cookies.slice(*self.class.login_cookies)
    missing_login_cookies = (self.class.login_cookies - login_cookies.keys)

    if missing_login_cookies.any?
      puts "* Didn't find all cookies. Missing: #{missing_cookies.inspect}.".yellow
      return nil
    end

    @cookies = login_cookies
    puts "* Got new #{self.class.name.demodulize} login cookies: #{@cookies.inspect}".yellow
    true
  end
end
