module Finicity::V1
  module Response
    class Customer
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :username
      attribute :email
      attribute :firstName, :as => :first_name
      attribute :lastName, :as => :last_name
      attribute :id
    end

    class Customers
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :customers
      attribute :moreAvailable, :attribute => true, :as => :more_available
      attribute :found, :attribute => true, :type => ::Integer
      attribute :displaying, :attribute => true, :type => ::Integer
      attribute :customer, :elements => true, :class => ::Finicity::V1::Response::Customer, :as => :customers

      ##
      # Instance Methods
      #
      def more_available?
        more_available == 'true'
      end
    end
  end
end
