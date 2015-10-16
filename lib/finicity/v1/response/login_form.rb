module Finicity::V1
  module Response
    class LoginField
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :description
      attribute :displayOrder, :type => ::Integer, :as => :display_order
      attribute :id
      attribute :name
      attribute :mask

      def mask?
        mask == 'true'
      end
    end

    class LoginForm
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :loginField, :elements => true, :class => ::Finicity::V1::Response::LoginField, :as => :login_fields
    end
  end
end
