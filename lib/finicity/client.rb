module Finicity
  class Client
    ##
    # Attributes
    #
    attr_accessor :mfa_session, :token

    ##
    # Constructor
    #
    def initialize(token = nil, mfa_session = nil)
      @token = token
      @mfa_session = mfa_session
    end

    ##
    # Instance Methods
    #
    # The accounts parameter is an array of Finicity::V1::Reponse::Account
    def activate_accounts(customer_id, institution_id, accounts)
      request = ::Finicity::V1::Request::ActivateAccounts.new(token, customer_id, institution_id, accounts)
      request.log_request
      response = request.activate_accounts
      log_response(response)

      if response.status_code == 200
        @mfa_session = nil
        parsed_response = ::Finicity::V1::Response::Accounts.parse(response.body)
        return parsed_response.accounts
      elsif response.status_code == 203
        @mfa_session = response.headers["MFA-Session"]
        parsed_response = ::Finicity::V1::Response::Mfa.parse(response.body)
        return parsed_response.questions
      else
        raise_generic_error!(response)
      end
    end

    # The accounts parameter is an array of Finicity::V1::Reponse::Account
    # The mfa_credentials parameter is an array of hashes with keys :text, :answer
    def activate_accounts_with_mfa(customer_id, institution_id, accounts, mfa_credentials)
      request = ::Finicity::V1::Request::ActivateAccountsWithMfa.new(token, mfa_session, customer_id, institution_id, accounts, mfa_credentials)
      request.log_request
      response = request.activate_accounts_with_mfa
      log_response(response)

      if response.status_code == 200
        @mfa_session = nil
        parsed_response = ::Finicity::V1::Response::Accounts.parse(response.body)
        return parsed_response.accounts
      elsif response.status_code == 203
        @mfa_session = response.headers["MFA-Session"]
        parsed_response = ::Finicity::V1::Response::Mfa.parse(response.body)
        return parsed_response.questions
      else
        raise_generic_error!(response)
      end
    end

    def add_customer(user_guid)
      request = ::Finicity::V1::Request::AddCustomer.new(token, user_guid)
      request.log_request
      response = request.add_customer
      log_response(response)

      if response.ok?
        parsed_response = ::Finicity::V1::Response::Customer.parse(response.body)
        return parsed_response
      else
        raise_generic_error!(response)
      end
    end

    def authenticate!
      request = ::Finicity::V2::Request::PartnerAuthentication.new
      response = request.authenticate

      if response.ok?
        parsed_response = ::Finicity::V2::Response::PartnerAuthentication.parse(response.body)
        @token = parsed_response.token
        parsed_response
      else
        fail ::Finicity::AuthenticationError.new(response.body, response.status_code)
      end
    end

    def delete_account(customer_id, account_id)
      request = ::Finicity::V1::Request::DeleteAccount.new(token, customer_id, account_id)
      request.log_request
      response = request.delete_account
      log_response(response)

      if response.ok?
        # No data to parse, so return a hash for consistent return type
        return {}
      else
        raise_generic_error!(response)
      end
    end

    def delete_customer(customer_id)
      request = ::Finicity::V1::Request::DeleteCustomer.new(token, customer_id)
      response = request.delete_customer

      if response.ok?
        # No data to parse, so return a hash for consistent return type
        return {}
      else
        raise_generic_error!(response)
      end
    end

    # The login_credentials parameter is an array of hashes with the keys :id, :name, :value
    def discover_accounts(customer_id, institution_id, login_credentials)
      request = ::Finicity::V1::Request::DiscoverAccounts.new(token, customer_id, institution_id, login_credentials)
      request.log_request
      response = request.discover_accounts
      log_response(response)

      if response.status_code == 200
        @mfa_session = nil
        parsed_response = ::Finicity::V1::Response::Accounts.parse(response.body)
        return parsed_response.accounts
      elsif response.status_code == 203
        @mfa_session = response.headers["MFA-Session"]
        parsed_response = ::Finicity::V1::Response::Mfa.parse(response.body)
        return parsed_response.questions
      else
        raise_generic_error!(response)
      end
    end

    # The login_credentials parameter is an array of hashes with the keys :id, :name, :value
    # The mfa_credentials parameter is an array of hashes with keys :text, :answer
    def discover_accounts_with_mfa(customer_id, institution_id, login_credentials, mfa_credentials)
      request = ::Finicity::V1::Request::DiscoverAccountsWithMfa.new(token, mfa_session, customer_id, institution_id, login_credentials, mfa_credentials)
      request.log_request
      response = request.discover_accounts_with_mfa
      log_response(response)

      if response.status_code == 200
        @mfa_session = nil
        parsed_response = ::Finicity::V1::Response::Accounts.parse(response.body)
        return parsed_response.accounts
      elsif response.status_code == 203
        @mfa_session = response.headers["MFA-Session"]
        parsed_response = ::Finicity::V1::Response::Mfa.parse(response.body)
        return parsed_response.questions
      else
        raise_generic_error!(response)
      end
    end

    def get_accounts(customer_id, institution_id)
      request = ::Finicity::V1::Request::GetAccounts.new(token, customer_id, institution_id)
      request.log_request
      response = request.get_accounts
      log_response(response)

      if response.ok?
        parsed_response = ::Finicity::V1::Response::Accounts.parse(response.body)
        return parsed_response.accounts
      elsif response.status_code == 404
        return []
      else
        raise_generic_error!(response)
      end
    end

    def get_customer_by_username(username)
      request = ::Finicity::V1::Request::GetCustomersByUsername.new(token, username, 1, 1)
      request.log_request
      response = request.get_customers_by_username
      log_response(response)

      if response.ok?
        parsed_response = ::Finicity::V1::Response::Customers.parse(response.body)
        if parsed_response.found && parsed_response.found > 1
          raise ::Finicity::DuplicateCustomerError.new(username)
        else
          return parsed_response.customers.first
        end
      else
        raise_generic_error!(response)
      end
    end

    def get_customers_by_username(username, start, limit)
      request = ::Finicity::V1::Request::GetCustomersByUsername.new(token, username, start, limit)
      request.log_request
      response = request.get_customers_by_username
      log_response(response)

      if response.ok?
        parsed_response = ::Finicity::V1::Response::Customers.parse(response.body)
        return parsed_response.customers
      else
        raise_generic_error!(response)
      end
    end

    def get_customers
      request = ::Finicity::V1::Request::GetCustomers.new(token)
      start = 1
      limit = 25
      customers = []

      loop do
        response = request.get_customers(start, limit)

        if response.ok?
          parsed_response = ::Finicity::V1::Response::Customers.parse(response.body)
          customers << parsed_response.customers

          if parsed_response.more_available?
            start += limit
          else
            return customers.flatten
          end
        else
          raise_generic_error!(response)
        end
      end
    end

    def get_institution(institution_id)
      request = ::Finicity::V1::Request::GetInstitution.new(token, institution_id)
      response = request.get_institution

      if response.ok?
        parsed_response = ::Finicity::V1::Response::Institution.parse(response.body)
        return parsed_response
      else
        raise_generic_error!(response)
      end
    end

    def get_institutions(institution_name)
      request = ::Finicity::V1::Request::GetInstitutions.new(token, institution_name)
      start = 1
      limit = 25
      institutions = []

      loop do
        response = request.get_institutions(start, limit)

        if response.ok?
          parsed_response = ::Finicity::V1::Response::Institutions.parse(response.body)
          institutions << parsed_response.institutions

          if parsed_response.more_available?
            start += limit
          else
            return institutions.flatten
          end
        else
          raise_generic_error!(response)
        end
      end
    end

    def get_login_form(institution_id)
      request = ::Finicity::V1::Request::GetLoginForm.new(token, institution_id)
      response = request.get_login_form

      if response.ok?
        parsed_response = ::Finicity::V1::Response::LoginForm.parse(response.body)
        return parsed_response.login_fields
      else
        raise_generic_error!(response)
      end
    end

    def get_transactions(customer_id, account_id, from_date, to_date)
      request = ::Finicity::V1::Request::GetTransactions.new(token, customer_id, account_id, from_date, to_date)
      request.log_request
      response = request.get_transactions
      log_response(response)

      if response.ok?
        parsed_response = ::Finicity::V1::Response::Transactions.parse(response.body)
        return parsed_response.transactions
      else
        raise_generic_error!(response)
      end
    end

    def interactive_refresh_account(customer_id, account_id)
      request = ::Finicity::V1::Request::InteractiveRefreshAccount.new(token, customer_id, account_id)
      request.log_request
      response = request.interactive_refresh_account
      log_response(response)

      if response.status_code == 200
        @mfa_session = nil
        parsed_response = ::Finicity::V1::Response::Accounts.parse(response.body)
        return parsed_response.accounts
      elsif response.status_code == 203
        @mfa_session = response.headers["MFA-Session"]
        parsed_response = ::Finicity::V1::Response::Mfa.parse(response.body)
        return parsed_response.questions
      else
        raise_generic_error!(response)
      end
    end

    # The mfa_credentials parameter is an array of hashes with keys :text, :answer
    def interactive_refresh_account_with_mfa(customer_id, account_id, mfa_credentials)
      request = ::Finicity::V1::Request::InteractiveRefreshAccountWithMfa.new(token, mfa_session, customer_id, account_id, mfa_credentials)
      request.log_request
      response = request.interactive_refresh_account_with_mfa
      log_response(response)

      if response.status_code == 200
        @mfa_session = nil
        parsed_response = ::Finicity::V1::Response::Accounts.parse(response.body)
        return parsed_response.accounts
      elsif response.status_code == 203
        @mfa_session = response.headers["MFA-Session"]
        parsed_response = ::Finicity::V1::Response::Mfa.parse(response.body)
        return parsed_response.questions
      else
        raise_generic_error!(response)
      end
    end

    def refresh_accounts(customer_id)
      request = ::Finicity::V1::Request::RefreshAccounts.new(token, customer_id)
      request.log_request
      response = request.refresh_accounts
      log_response(response)

      if response.ok?
        parsed_response = ::Finicity::V1::Response::Accounts.parse(response.body)
        return parsed_response.accounts
      else
        raise_generic_error!(response)
      end
    end

    # The login_credentials parameter is an array of hashes with the keys :id, :name, :value
    def update_credentials(customer_id, account_id, login_credentials)
      request = ::Finicity::V1::Request::UpdateCredentials.new(token, customer_id, account_id, login_credentials)
      request.log_request
      response = request.update_credentials
      log_response(response)

      if response.ok?
        # No data to parse, so return a hash for consistent return type
        return {}
      else
        raise_generic_error!(response)
      end
    end

    private

    def log_response(response)
      ::Finicity.logger.debug do
        log = "RESPONSE"
        log << "\n  STATUS CODE: #{response.status_code}"
        log << "\n  BODY: #{response.body}"
        log
      end
    end

    def raise_generic_error!(response)
      if response.content_type =~ /application\/xml/i
        error = ::Finicity::V1::Response::Error.parse(response.body)
        error_message = error.message
        error_code = error.code
      else
        error_message = response.body
        error_code = nil
      end

      # Finicity API uses 500 status code, with a 103 code in the body to communicate
      # that the credentials are invalid.
      if response.status_code == 500 && error_code == 103
        fail ::Finicity::InvalidCredentialsError.new(103)
      else
        fail ::Finicity::GenericError.new(error_message, response.status_code, error_code)
      end
    end

  end
end
