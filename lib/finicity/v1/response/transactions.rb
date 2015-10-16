module Finicity::V1
  module Response
    class Transaction
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :id
      attribute :amount, :type => ::Float
      attribute :accountId, :as => :account_id
      attribute :customerId, :as => :customer_id
      attribute :description
      attribute :memo
      attribute :postedDate, :type => ::Integer, :as => :posted_date
      attribute :status
    end

    class Transactions
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :transaction, :elements => true, :class => ::Finicity::V1::Response::Transaction, :as => :transactions
    end
  end
end
