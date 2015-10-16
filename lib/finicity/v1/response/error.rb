module Finicity::V1
  module Response
    class Error
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :code, :type => ::Integer
      attribute :message
    end
  end
end
