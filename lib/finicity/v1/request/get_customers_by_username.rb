module Finicity::V1
  module Request
    class GetCustomersByUsername
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :limit,
        :start,
        :token,
        :username

      ##
      # Instance Methods
      #
      def initialize(token, username, start, limit)
        @limit = limit
        @start = start
        @token = token
        @username = username
      end

      def get_customers_by_username
        http_client.get(url, query, headers)
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token
        }
      end

      def query
        { :search => username, :start => start, :limit => limit }
      end

      def url
        ::URI.join(
          ::Finicity.config.base_url,
          'v1/',
          'customers'
        )
      end
    end
  end
end
