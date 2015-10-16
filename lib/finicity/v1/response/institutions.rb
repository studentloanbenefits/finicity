module Finicity::V1
  module Response
    class Institution
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :id
      attribute :name
      attribute :accountTypeDescription, :as => :account_type_description
      attribute :totalAccounts, :type => ::Integer, :as => :total_accounts
      attribute :discovery
      attribute :urlHomeApp, :as => :url_home_app
      attribute :urlLogonApp, :as => :url_logon_app
    end

    class Institutions
      include ::Saxomattic

      ##
      # Saxomattic Attributes
      #
      attribute :institutions
      attribute :moreAvailable, :attribute => true, :as => :more_available
      attribute :found, :attribute => true, :type => ::Integer
      attribute :displaying, :attribute => true, :type => ::Integer
      attribute :institution, :elements => true, :class => ::Finicity::V1::Response::Institution, :as => :institutions

      ##
      # Instance Methods
      #
      def more_available?
        more_available == 'true'
      end
    end
  end
end
