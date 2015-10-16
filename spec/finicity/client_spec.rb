require 'spec_helper'

describe ::Finicity::Client do
  let(:mfa_session_token) { 'mfa-123' }
  let(:response) { instance_double(::HTTP::Message, :ok? => true, :status_code => 200, :body => "hello") }
  let(:not_found) { instance_double(::HTTP::Message, :ok? => false, :status_code => 404, :body => "not found") }
  let(:mfa) {
    instance_double(
      ::HTTP::Message,
      :ok? => true,
      :status_code => 203,
      :body => "challenge",
      :headers => { 'MFA-Session' => mfa_session_token }
    )
  }
  let(:error) {
    instance_double(
      ::HTTP::Message,
      :ok? => false,
      :status_code => 400,
      :body => "fail",
      :content_type => "text/plain"
    )
  }
  let(:aggregation_error) {
    instance_double(
      ::HTTP::Message,
      :ok? => false,
      :status_code => 500,
      :body => '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><error><code>103</code><message>Aggregation error.</message></error>',
      :content_type => "application/xml"
    )
  }

  describe "#activate_accounts" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::ActivateAccounts).to(
          receive(:activate_accounts).and_return(response)
        )
        response = subject.activate_accounts(123, 1, [])
        response.should eq([])
      end
    end

    context "when the response is mfa" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::ActivateAccounts).to(
          receive(:activate_accounts).and_return(mfa)
        )
        response = subject.activate_accounts(123, 1, [])
        response.should eq([])
      end

      it "sets the mfa session token" do
        allow_any_instance_of(::Finicity::V1::Request::ActivateAccounts).to(
          receive(:activate_accounts).and_return(mfa)
        )
        response = subject.activate_accounts(123, 1, [])
        subject.mfa_session.should eq(mfa_session_token)
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::ActivateAccounts).to(
          receive(:activate_accounts).and_return(error)
        )
        expect { subject.activate_accounts(123, 1, []) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#activate_accounts_with_mfa" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::ActivateAccountsWithMfa).to(
          receive(:activate_accounts_with_mfa).and_return(response)
        )
        response = subject.activate_accounts_with_mfa(123, 1, [], [])
        response.should eq([])
      end
    end

    context "when the response is mfa" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::ActivateAccountsWithMfa).to(
          receive(:activate_accounts_with_mfa).and_return(mfa)
        )
        response = subject.activate_accounts_with_mfa(123, 1, [], [])
        response.should eq([])
      end

      it "sets the mfa session token" do
        allow_any_instance_of(::Finicity::V1::Request::ActivateAccountsWithMfa).to(
          receive(:activate_accounts_with_mfa).and_return(mfa)
        )
        response = subject.activate_accounts_with_mfa(123, 1, [], [])
        subject.mfa_session.should eq(mfa_session_token)
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::ActivateAccountsWithMfa).to(
          receive(:activate_accounts_with_mfa).and_return(error)
        )
        expect { subject.activate_accounts_with_mfa(123, 1, [], []) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#add_customer" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::AddCustomer).to(
          receive(:add_customer).and_return(response)
        )
        response = subject.add_customer('USR-123')
        response.id.should be_nil
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::AddCustomer).to(
          receive(:add_customer).and_return(error)
        )
        expect { subject.add_customer('USR-123') }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#authenticate!" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V2::Request::PartnerAuthentication).to(
          receive(:authenticate).and_return(response)
        )
        response = subject.authenticate!
        response.token.should be_nil
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V2::Request::PartnerAuthentication).to(
          receive(:authenticate).and_return(error)
        )
        expect { subject.authenticate! }.to raise_error(::Finicity::AuthenticationError)
      end
    end
  end

  describe "#delete_account" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::DeleteAccount).to(
          receive(:delete_account).and_return(response)
        )
        response = subject.delete_account(1, 2)
        response.should eq({})
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::DeleteAccount).to(
          receive(:delete_account).and_return(error)
        )
        expect { subject.delete_account(1, 2) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#delete_customer" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::DeleteCustomer).to(
          receive(:delete_customer).and_return(response)
        )
        response = subject.delete_customer(123)
        response.should eq({})
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::DeleteCustomer).to(
          receive(:delete_customer).and_return(error)
        )
        expect { subject.delete_customer(123) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#discover_accounts" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::DiscoverAccounts).to(
          receive(:discover_accounts).and_return(response)
        )
        response = subject.discover_accounts(123, 1, [])
        response.should eq([])
      end
    end

    context "when the response is mfa" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::DiscoverAccounts).to(
          receive(:discover_accounts).and_return(mfa)
        )
        response = subject.discover_accounts(123, 1, [])
        response.should eq([])
      end

      it "sets the mfa session token" do
        allow_any_instance_of(::Finicity::V1::Request::DiscoverAccounts).to(
          receive(:discover_accounts).and_return(mfa)
        )
        response = subject.discover_accounts(123, 1, [])
        subject.mfa_session.should eq(mfa_session_token)
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::DiscoverAccounts).to(
          receive(:discover_accounts).and_return(error)
        )
        expect { subject.discover_accounts(123, 1, []) }.to raise_error(::Finicity::GenericError)
      end
    end

    context "when the response is an aggregation error" do
      it "fails with InvalidCredentials" do
        allow_any_instance_of(::Finicity::V1::Request::DiscoverAccounts).to(
          receive(:discover_accounts).and_return(aggregation_error)
        )
        expect { subject.discover_accounts(123, 1, []) }.to raise_error(::Finicity::InvalidCredentialsError)
      end
    end
  end

  describe "#discover_accounts_with_mfa" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::DiscoverAccountsWithMfa).to(
          receive(:discover_accounts_with_mfa).and_return(response)
        )
        response = subject.discover_accounts_with_mfa(123, 1, [], [])
        response.should eq([])
      end
    end

    context "when the response is mfa" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::DiscoverAccountsWithMfa).to(
          receive(:discover_accounts_with_mfa).and_return(mfa)
        )
        response = subject.discover_accounts_with_mfa(123, 1, [], [])
        response.should eq([])
      end

      it "sets the mfa session token" do
        allow_any_instance_of(::Finicity::V1::Request::DiscoverAccountsWithMfa).to(
          receive(:discover_accounts_with_mfa).and_return(mfa)
        )
        response = subject.discover_accounts_with_mfa(123, 1, [], [])
        subject.mfa_session.should eq(mfa_session_token)
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::DiscoverAccountsWithMfa).to(
          receive(:discover_accounts_with_mfa).and_return(error)
        )
        expect { subject.discover_accounts_with_mfa(123, 1, [], []) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#get_accounts" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::GetAccounts).to(
          receive(:get_accounts).and_return(response)
        )
        response = subject.get_accounts(1, 2)
        response.should eq([])
      end
    end

    context "when the response is 404" do
      it "returns an empty array" do
        allow_any_instance_of(::Finicity::V1::Request::GetAccounts).to(
          receive(:get_accounts).and_return(not_found)
        )
        response = subject.get_accounts(1, 2)
        response.should eq([])
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::GetAccounts).to(
          receive(:get_accounts).and_return(error)
        )
        expect { subject.get_accounts(1, 2) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#get_customer_by_username" do
    context "when the response is successful" do
      let(:single_customer) { ::Finicity::V1::Response::Customers.new(:found => 1) }

      it "returns the parsed response" do
        allow(::Finicity::V1::Response::Customers).to receive(:parse).and_return(single_customer)
        allow_any_instance_of(::Finicity::V1::Request::GetCustomersByUsername).to(
          receive(:get_customers_by_username).and_return(response)
        )
        response = subject.get_customer_by_username("USR-123")
        response.should be_nil
      end
    end

    context "response contains multiple customers" do
      let(:multiple_customers) { ::Finicity::V1::Response::Customers.new(:found => 2) }

      it "raises an error" do
        allow(::Finicity::V1::Response::Customers).to receive(:parse).and_return(multiple_customers)
        allow_any_instance_of(::Finicity::V1::Request::GetCustomersByUsername).to(
          receive(:get_customers_by_username).and_return(response)
        )
        expect { subject.get_customer_by_username("USR-123") }.to raise_error(
          ::Finicity::DuplicateCustomerError
        )
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::GetCustomersByUsername).to(
          receive(:get_customers_by_username).and_return(error)
        )
        expect { subject.get_customer_by_username("USR-123") }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#get_customers_by_username" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::GetCustomersByUsername).to(
          receive(:get_customers_by_username).and_return(response)
        )
        response = subject.get_customers_by_username(1, 1, 25)
        response.should eq([])
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::GetCustomersByUsername).to(
          receive(:get_customers_by_username).and_return(error)
        )
        expect { subject.get_customers_by_username(1, 1, 25) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#get_customers" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::GetCustomers).to(
          receive(:get_customers).and_return(response)
        )
        response = subject.get_customers
        response.should eq([])
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::GetCustomers).to(
          receive(:get_customers).and_return(error)
        )
        expect { subject.get_customers }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#get_institution" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::GetInstitution).to(
          receive(:get_institution).and_return(response)
        )
        response = subject.get_institution(1)
        response.should be_a(::Finicity::V1::Response::Institution)
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::GetInstitution).to(
          receive(:get_institution).and_return(error)
        )
        expect { subject.get_institution(1) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#get_institutions" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::GetInstitutions).to(
          receive(:get_institutions).and_return(response)
        )
        response = subject.get_institutions("chase")
        response.should eq([])
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::GetInstitutions).to(
          receive(:get_institutions).and_return(error)
        )
        expect { subject.get_institutions("chase") }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#get_login_form" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::GetLoginForm).to(
          receive(:get_login_form).and_return(response)
        )
        response = subject.get_login_form(1234)
        response.should eq([])
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::GetLoginForm).to(
          receive(:get_login_form).and_return(error)
        )
        expect { subject.get_login_form(1234) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#get_transactions" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::GetTransactions).to(
          receive(:get_transactions).and_return(response)
        )
        response = subject.get_transactions(123, 1, 1, 2)
        response.should eq([])
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::GetTransactions).to(
          receive(:get_transactions).and_return(error)
        )
        expect { subject.get_transactions(123, 1, 1 ,2) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#interactive_refresh_account" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::InteractiveRefreshAccount).to(
          receive(:interactive_refresh_account).and_return(response)
        )
        response = subject.interactive_refresh_account(123, 1)
        response.should eq([])
      end
    end

    context "when the response is mfa" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::InteractiveRefreshAccount).to(
          receive(:interactive_refresh_account).and_return(mfa)
        )
        response = subject.interactive_refresh_account(123, 1)
        response.should eq([])
      end

      it "sets the mfa session token" do
        allow_any_instance_of(::Finicity::V1::Request::InteractiveRefreshAccount).to(
          receive(:interactive_refresh_account).and_return(mfa)
        )
        response = subject.interactive_refresh_account(123, 1)
        subject.mfa_session.should eq(mfa_session_token)
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::InteractiveRefreshAccount).to(
          receive(:interactive_refresh_account).and_return(error)
        )
        expect { subject.interactive_refresh_account(123, 1) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#interactive_refresh_account_with_mfa" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::InteractiveRefreshAccountWithMfa).to(
          receive(:interactive_refresh_account_with_mfa).and_return(response)
        )
        response = subject.interactive_refresh_account_with_mfa(123, 1, [])
        response.should eq([])
      end
    end

    context "when the response is mfa" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::InteractiveRefreshAccountWithMfa).to(
          receive(:interactive_refresh_account_with_mfa).and_return(mfa)
        )
        response = subject.interactive_refresh_account_with_mfa(123, 1, [])
        response.should eq([])
      end

      it "sets the mfa session token" do
        allow_any_instance_of(::Finicity::V1::Request::InteractiveRefreshAccountWithMfa).to(
          receive(:interactive_refresh_account_with_mfa).and_return(mfa)
        )
        response = subject.interactive_refresh_account_with_mfa(123, 1, [])
        subject.mfa_session.should eq(mfa_session_token)
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::InteractiveRefreshAccountWithMfa).to(
          receive(:interactive_refresh_account_with_mfa).and_return(error)
        )
        expect { subject.interactive_refresh_account_with_mfa(123, 1, []) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#refresh_accounts" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::RefreshAccounts).to(
          receive(:refresh_accounts).and_return(response)
        )
        response = subject.refresh_accounts(1)
        response.should eq([])
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::RefreshAccounts).to(
          receive(:refresh_accounts).and_return(error)
        )
        expect { subject.refresh_accounts(1) }.to raise_error(::Finicity::GenericError)
      end
    end
  end

  describe "#update_credentials" do
    context "when the response is successful" do
      it "returns the parsed response" do
        allow_any_instance_of(::Finicity::V1::Request::UpdateCredentials).to(
          receive(:update_credentials).and_return(response)
        )
        response = subject.update_credentials(1, 2, [])
        response.should eq({})
      end
    end

    context "when the response is an error" do
      it "fails" do
        allow_any_instance_of(::Finicity::V1::Request::UpdateCredentials).to(
          receive(:update_credentials).and_return(error)
        )
        expect { subject.update_credentials(1, 2, []) }.to raise_error(::Finicity::GenericError)
      end
    end
  end
end
