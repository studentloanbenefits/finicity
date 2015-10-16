module Finicity::V1
  module Request
    class DiscoverAccounts
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
        :login_credentials,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, institution_id, login_credentials)
        @customer_id = customer_id
        @institution_id = institution_id
        @login_credentials = login_credentials
        @token = token
      end

      def discover_accounts
        http_client.post(url, body, headers)
      end

      def body
        builder = ::Nokogiri::XML::Builder.new do |xml|
          xml.accounts {
            xml.credentials {
              login_credentials.each do |login_credential|
                xml.loginField {
                  xml.id(login_credential[:id])
                  xml.name(login_credential[:name])
                  xml.value(login_credential[:value])
                }
              end
            }
          }
        end

        builder.to_xml
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
          'institutions/',
          "#{institution_id}/",
          'accounts'
        )
      end
    end
  end
end
