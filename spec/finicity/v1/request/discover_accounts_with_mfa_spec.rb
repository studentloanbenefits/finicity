require 'spec_helper'

describe ::Finicity::V1::Request::DiscoverAccountsWithMfa do
  let(:login_credential) {
    {
      :id => '1',
      :name => 'username',
      :value => 'test_user'
    }
  }
  let(:mfa_credential) {
    {
      :text => 'What is your birthday?',
      :answer => '1985-01-01'
    }
  }
  let(:login_credentials) { [login_credential] }
  let(:mfa_credentials) { [mfa_credential] }

  subject { described_class.new("token-123", "mfa_session-123", 1, 2, login_credentials, mfa_credentials) }

  describe "#headers" do
    it "has correct headers" do
      subject.headers.should have_key('Finicity-App-Key')
      subject.headers.should have_key('Finicity-App-Token')
      subject.headers.should have_key('Content-Type')
      subject.headers.should have_key('MFA-Session')
    end
  end

  describe "#body" do

    it "forms the correct id" do
      subject.body.should include("<id>1</id>")
    end

    it "forms the correct name" do
      subject.body.should include("<name>username</name>")
    end

    it "forms the correct value" do
      subject.body.should include("<value>test_user</value>")
    end

    it "forms the mfa question" do
      subject.body.should include("<text>What is your birthday?</text>")
    end

    it "forms the mfa answer" do
      subject.body.should include("<answer>1985-01-01</answer>")
    end
  end

  describe "#url" do
    it "has a correct url" do
      subject.url.to_s.should include('customers/1/institutions/2/accounts/mfa')
    end
  end
end
