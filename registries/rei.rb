#!/usr/bin/env ruby

class Registries::Rei < PrivateRegistry
  @login_url = 'https://www.rei.com/user/login'
  @login_cookies = [
    "loggedin",
    "REI_SESSION_ID",
    "REI_SSL_SESSION_ID",
    # TODO are any of the following needed? are all of the previous required?
    # "rei_user_info",
    # "rei_cart",
    # "events_cart",
    # "bvAuth",
    # "rei_cart",
    # "TS019bf215",
    # "TS019bf215_30",
    # "akamai_session",
  ]

  def initialize(params={})
    params.symbolize_keys!
    params.merge!(:login_params => {
      :storeId => "8000",
      :toUrl => "/YourAccountInfoInView",
      :URL => "/YourAccountInfoInView",
      :context => "YourAccount",
      :template => "yourAccountLoginCq",
      :displayScreenName => "",
      # TODO fix token - is this dynamically generated??
      :token => "igI69iUE0qPIUoFSLBc81vkLlRr0jNQUJvvuuzU0",
      :token_map => "email=logonId",
      :submit2 => "submit2",
      :logonId => params.delete(:email),
      :password => params.delete(:password),
    })

    super(params)
  end

private

  def authenticated?(doc)
    doc.css('head title').text.strip == "Review Your Registry List"
  end

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
    requested = product.css('td')[4].css('input')[0]['value'].to_i
    purchased = product.css('td')[5].text.strip.to_i
    requested - purchased
  end
end
