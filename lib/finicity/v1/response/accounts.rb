module Finicity::V1
  module Response
    class Account
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :id
      attribute :number, :type => ::Integer
      attribute :name
      attribute :balance, :type => ::Float
      attribute :type
      attribute :aggregationStatusCode, :type => ::Integer, :as => :aggregation_status_code
      attribute :status, :type => ::Integer
      attribute :customerId, :as => :customer_id
      attribute :institutionId, :as => :institution_id
      attribute :balanceDate, :type => ::Integer
      attribute :aggregationSuccessDate, :type => ::Integer
      attribute :aggregationAttemptDate, :type => ::Integer
      attribute :createdDate, :type => ::Integer
      attribute :paymentMinAmount, :type => ::Float, :as => :payment_min_amount
      attribute :paymentDueDate, :type => ::Integer
      attribute :statementCloseBalance, :type => ::Float, :as => :statement_close_balance
      attribute :statementEndDate, :type => ::Integer

      ##
      # Instance Methods
      #
      def aggregation_success_date
        aggreagtionSuccessDate ? ::Time.at(aggregationSuccessDate).utc : nil
      end

      def aggregation_attempt_date
        aggreagtionAttemptDate ? ::Time.at(aggregationAttemptDate).utc : nil
      end

      def balance_date
        balanceDate ? ::Time.at(balanceDate).utc : nil
      end

      def created_date
        createdDate ? ::Time.at(createdDate).utc : nil
      end

      def payment_due_date
        paymentDueDate ? ::Time.at(paymentDueDate).utc : nil
      end

      def statement_end_date
        statementEndDate ? ::Time.at(statementEndDate).utc : nil
      end

      def validate_aggregation_status!
        case aggregation_status_code
        when 0
          true
        when 103, 108, 109, 185, 187
          fail ::Finicity::InvalidCredentialsError.new(aggregation_status_code)
        else
          fail ::Finicity::FinicityAggregationError.new(aggregation_status_code)
        end
      end
    end

    class Accounts
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :account, :elements => true, :class => ::Finicity::V1::Response::Account, :as => :accounts
    end
  end
end
