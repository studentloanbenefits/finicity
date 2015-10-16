module Finicity::V1
  module Request
    class DeleteCustomer
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :token,
        :customer_id

      ##
      # Instance Methods
      #
      def initialize(token, customer_id)
        @customer_id = customer_id
        @token = token
      end

      def delete_customer
        http_client.delete(url, nil, headers)
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token
        }
      end

      def url
        ::URI.join(
          ::Finicity.config.base_url,
          'v1/',
          'customers/',
          customer_id.to_s
        )
      end
    end
  end
end
