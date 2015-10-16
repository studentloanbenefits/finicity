module Finicity::V1
  module Request
    class DiscoverAccountsWithMfa
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
        :mfa_credentials,
        :mfa_session,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, mfa_session, customer_id, institution_id, login_credentials, mfa_credentials)
        @customer_id = customer_id
        @institution_id = institution_id
        @login_credentials = login_credentials
        @mfa_credentials = mfa_credentials
        @mfa_session = mfa_session
        @token = token
      end

      def discover_accounts_with_mfa
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
          'MFA-Session' => mfa_session,
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
          'accounts/',
          'mfa'
        )
      end
    end
  end
end
