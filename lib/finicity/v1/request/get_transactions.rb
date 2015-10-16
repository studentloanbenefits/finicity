module Finicity::V1
  module Request
    class GetTransactions
      include ::Finicity::Logger
      extend ::HTTPClient::IncludeClient
      include_http_client do |client|
        client.cookie_manager = nil
      end

      ##
      # Attributes
      #
      attr_accessor :account_id,
        :customer_id,
        :from_date,
        :to_date,
        :token

      ##
      # Instance Methods
      #
      def initialize(token, customer_id, account_id, from_date, to_date)
        @account_id = account_id
        @customer_id = customer_id
        @from_date = from_date
        @to_date = to_date
        @token = token
      end

      def get_transactions
        http_client.get(url, query, headers)
      end

      def headers
        {
          'Finicity-App-Key' => ::Finicity.config.app_key,
          'Finicity-App-Token' => token,
          'Content-Type' => 'application/xml'
        }
      end

      def query
        { :fromDate => from_date, :toDate => to_date }
      end

      def url
        ::URI.join(
          ::Finicity.config.base_url,
          'v1/',
          'customers/',
          "#{customer_id}/",
          'accounts/',
          "#{account_id}/",
          'transactions'
        )
      end

    end
  end
end
