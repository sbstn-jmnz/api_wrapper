require 'dotenv/load'
module ApiWrapper
  require 'net/http'
  require 'json'

  def success?(res)
    res.is_a?(Net::HTTPSuccess)
  end

  def parse_response(res)
    JSON.parse(res.body)
  end

  def sii_date_format(date)
    date.strftime('%d%m%Y')
  end

  def get_response(uri)
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri
      response = http.request(request)
      if response.code == '200' || response.code == '500'
        return response
      else
        puts response.body
        puts response.code
         sleep(2)
        get_response(uri)
      end
    end
  end

  class PurchaseOrders
    include ApiWrapper
    #'pos' is short for purchase_orders, 'po' for singular
    attr_accessor :api_key, :uri

    def initialize
      @api_key = ENV['PUBLIC_MARKET_API_KEY']
      @uri = ENV['PO_API_URI']
    end

    def get_po(code)
      uri = URI(@uri + 'codigo=' + code + '&ticket=' + @api_key)
      response = get_response(uri)
      parse_response(response)
    end

    def get_all_pos_from_today
      #code
    end

    def get_all_pos_by_date(date)
      #code
    end

    def get_pos_by_state_from_today(state='todos')
      #code
    end

    def get_pos_by_state_and_date(state, date)
      #code
    end

    def get_pos_by_entity_and_date(entity_code, date)
      date = sii_date_format(date)
      uri = URI(@uri + 'fecha=' + date + '&CodigoOrganismo=' + entity_code + '&ticket=' + @api_key)
      response = get_response(uri)
      if success?(response)
        parse_response(response)['Listado']
      end
    end

    def get_pos_by_seller_and_date(seller_code, date)
      date = sii_date_format(date)
      uri = URI(@uri + 'fecha=' + date + '&CodigoProveedor=' + seller_code + '&ticket=' + @api_key)
      response = get_response(uri)
      if success?(response)
        parse_response(response)['Listado']
      end
    end

  end

  class Seller
    include ApiWrapper
    attr_accessor :api_key, :uri

    def initialize
      @api_key = ENV['PUBLIC_MARKET_API_KEY']
      @uri = ENV['SELLER_API_URI']
    end

    def get_seller_hash(dni)
      uri = URI(@uri + 'rutempresaproveedor=' + dni + '&ticket=' + @api_key)
      response = get_response(uri)
      if response.code == '200'
        parse_response(response)['listaEmpresas'][0]
      elsif response.code == '500'
        {'CodigoEmpresa' => nil, 'NombreEmpresa'=> nil}
      end
    end
  end


  class Entity
    include ApiWrapper
    attr_accessor :api_key, :uri

    def initialize
      @api_key = ENV['PUBLIC_MARKET_API_KEY']
      @uri = ENV['ENTITY_API_URI']
    end

    def get_all_entities
      response = set_up_response
      list = []
      if success?(response)
         parse_response(response)['listaEmpresas'].each do |entity|
           list.push([ entity['NombreEmpresa'], entity['CodigoEmpresa']])
         end
      end
      return list
    end

    def get_entity(code)
      response = set_up_response
      entity = {}
      if success?(response)
         parse_response(response)['listaEmpresas'].each do |en|
            if en['CodigoEmpresa'] === code
              entity = { name: en['NombreEmpresa'], code: en['CodigoEmpresa'] }
            end
         end
      end
      return entity
    end

    def set_up_response
      uri = URI(@uri + 'ticket=' + @api_key)
      Net::HTTP.get_response(uri)
    end
  end


end
