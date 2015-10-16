module Finicity::V1
  module Request
    class GetInstitution
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :institution_id,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, institution_id)
        @institution_id = institution_id
        @token = token
      end

      def get_institution
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
          'institutions/',
          institution_id.to_s
        )
      end
    end
  end
end
