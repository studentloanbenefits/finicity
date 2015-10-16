module Finicity::V1
  module Request
    class GetAccounts
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :customer_id,
        :institution_id,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, institution_id)
        @customer_id = customer_id
        @institution_id = institution_id
        @token = token
      end

      def get_accounts
        http_client.get(url, nil, headers)
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
          "#{customer_id}/",
          'institutions/',
          "#{institution_id}/",
          'accounts'
        )
      end
    end
  end
end
