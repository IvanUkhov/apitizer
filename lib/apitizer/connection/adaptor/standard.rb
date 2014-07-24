require 'net/https'
require 'uri'

module Apitizer
  module Connection
    module Adaptor
      class Standard
        def process(method, address, parameters = {}, headers = {})
          uri = URI(address)

          request = build_request(method, address, parameters)
          headers.each { |k, v| request[k] = v }

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true if address =~ /^https:/

          response = http.request(request)
          [ response.code.to_i, response.to_hash, Array(response.body) ]
        rescue NoMethodError
          raise
        rescue NameError
          raise Error, 'Invalid method'
        rescue SocketError
          raise Error, 'Connection failed'
        end

        private

        def build_request(method, address, parameters)
          klass = Net::HTTP.const_get(method.to_s.capitalize)

          return klass.new(address) if parameters.empty?

          parameters = Helper.build_query(parameters)

          if klass == Net::HTTP::Get
            request = klass.new([ address, parameters ].join('?'))
          else
            request = klass.new(address)
            request.body = parameters
            request['Content-Type'] = [
              'application/x-www-form-urlencoded',
              "charset=#{ parameters.encoding.to_s }"
            ].join('; ')
          end

          request
        end
      end
    end
  end
end
