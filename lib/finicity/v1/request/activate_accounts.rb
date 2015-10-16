module Finicity::V1
  module Request
    class ActivateAccounts
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :accounts,
        :customer_id,
        :institution_id,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, institution_id, accounts)
        @accounts = accounts
        @customer_id = customer_id
        @institution_id = institution_id
        @token = token
      end

      # The accounts parameter is the finicity representation of accounts
      def activate_accounts
        http_client.put(url, body, headers)
      end

      # The accounts parameter is the finicity representation of accounts
      def body
        builder = ::Nokogiri::XML::Builder.new do |xml|
          xml.accounts {
            accounts.each do |account|
              xml.account {
                xml.id(account.id)
                xml.number(account.number)
                xml.name(account.name)
                xml.type(account.type)
              }
            end
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
