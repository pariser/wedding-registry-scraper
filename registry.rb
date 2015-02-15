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
    result = Unirest.get(@url)
    Nokogiri::HTML(result.body)
  end
end

# ----------------------------

class PrivateRegistry < Registry
  class << self
    # Required class instance variables
    attr_accessor :login_url
    attr_accessor :login_cookies
  end

  REQUIRED_PARAMS = [
    :url,
    :login_params,
  ]

  OPTIONAL_PARAMS = [
    :cookies
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

    cookie_string = @cookies.map { |k, v| "#{k}=#{v}" }.join("; ")
    puts "GET  #{@url} with cookie: #{cookie_string}" if @debug

    result = Unirest.get(@url, :headers => { :cookie => cookie_string })

    doc = Nokogiri::HTML(result.body)
    authenticated = authenticated?(doc)

    if !authenticated && should_retry
      puts "* Retrying login to #{@name}"
      login!

      result = Unirest.get(@url, :headers => { :cookie => @cookie })
      doc = Nokogiri::HTML(result.body)
      authenticated = authenticated?(doc)
    end

    raise AuthenticationFailed if !authenticated

    doc
  end

  def login!
    puts "POST to #{self.class.login_url}, params #{@login_params.inspect}" if @debug
    login_result = Unirest.post self.class.login_url, :parameters => @login_params
    puts "     RESULT #{login_result.inspect}" if @debug
    puts "     COOKIES #{login_result.headers[:set_cookie]}" if @debug

    cookies = login_result.headers[:set_cookie].reduce({}) do |cookies, cookie|
      key, value = cookie.split(';')[0].split('=')
      cookies.merge!(key => value)
    end

    login_cookies = cookies.reduce({}) do |hash, pair|
      key, value = pair
      hash[key] = value if self.class.login_cookies.include?(key)
      hash
    end

    return false if login_cookies.length < self.class.login_cookies.length

    @cookies = login_cookies
    puts "* Got new #{self.class.name.demodulize} login cookies: #{@cookies.inspect}".yellow
    true
  end
end
