module Finicity::V1
  module Response
    class Question
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :text
      attribute :choice, :elements => true, :as => :choices
    end

    class Mfa
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :questions, :elements => true, :class => ::Finicity::V1::Response::Question
    end
  end
end
