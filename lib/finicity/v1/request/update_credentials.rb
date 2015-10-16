module Finicity::V1
  module Request
    class UpdateCredentials
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :account_id, :customer_id, :login_credentials, :token

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, account_id, login_credentials)
        @account_id = account_id
        @customer_id = customer_id
        @login_credentials = login_credentials
        @token = token
      end

      def body
        builder = ::Nokogiri::XML::Builder.new do |xml|
          xml.loginForm {
            login_credentials.each do |login_credential|
              xml.loginField {
                xml.id(login_credential[:id])
                xml.value(login_credential[:value])
              }
            end
          }
        end

        builder.to_xml
      end

      def update_credentials
        http_client.put(url, body, headers)
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
          "#{customer_id}/",
          'accounts/',
          "#{account_id}/",
          'loginForm'
        )
      end
    end
  end
end
