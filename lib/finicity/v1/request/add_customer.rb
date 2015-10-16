module Finicity::V1
  module Request
    class AddCustomer
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :token,
        :user_guid, :user_email, :user_first_name, :user_last_name

      ##
      # Instance Methods
      #
      def initialize(token, user_guid, user_email, user_first_name, user_last_name)
        @token = token
        @user_guid       = user_guid
        @user_email      = user_email
        @user_first_name = user_first_name
        @user_last_name  = user_last_name
      end

      def add_customer
        http_client.post(url, body, headers)
      end

      def body
        {
          'username' => user_guid,
          'email' => user_email,
          'firstName' => user_first_name,
          'lastName' => user_last_name,
        }.to_xml(:root => 'customer')
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'Content-Type' => 'application/xml'
        }
      end

      def url
        ::URI.join(
          ::Finicity.config.base_url,
          'v1/',
          'customers/',
          'active'
        )
      end
    end
  end
end
