module Finicity::V2
  module Request
    class PartnerAuthentication
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Instance Methods
      #
      def authenticate
        http_client.post(url, body, headers)
      end

      def body
        builder = ::Nokogiri::XML::Builder.new do |xml|
          xml.credentials do
            xml.partnerId(::Finicity.config.partner_id)
            xml.partnerSecret(::Finicity.config.partner_secret)
          end
        end

        builder.doc.root.to_s
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Content-Type' => 'application/xml'
        }
      end

      def url
        ::URI.join(::Finicity.config.base_url, 'v2/partners/authentication')
      end
    end
  end
end
