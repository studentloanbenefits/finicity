module Finicity::V1
  module Request
    class ActivateAccountsWithMfa
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
        :mfa_credentials,
        :mfa_session,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, mfa_session, customer_id, institution_id, accounts, mfa_credentials)
        @accounts = accounts
        @customer_id = customer_id
        @institution_id = institution_id
        @mfa_credentials = mfa_credentials
        @mfa_session = mfa_session
        @token = token
      end

      def activate_accounts_with_mfa
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
            xml.mfaChallenges {
              xml.questions {
                mfa_credentials.each do |mfa_credential|
                  xml.question {
                    xml.text_(mfa_credential[:text])
                    xml.answer(mfa_credential[:answer])
                  }
                end
              }
            }
          }
        end

        builder.to_xml
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'Content-Type' => 'application/xml',
          'MFA-Session' => mfa_session,
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
          'accounts/',
          'mfa'
        )
      end

    end
  end
end
