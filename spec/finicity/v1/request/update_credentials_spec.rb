require 'spec_helper'

describe ::Finicity::V1::Request::UpdateCredentials do
  let(:login_credential) {
    {
      :id => '1',
      :name => 'username',
      :value => 'test_user'
    }
  }
  let(:login_credentials) { [login_credential] }

  subject { described_class.new("token-123", 1, 2, login_credentials) }

  describe "#headers" do
    it "has correct headers" do
      subject.headers.should have_key('Finicity-App-Key')
      subject.headers.should have_key('Finicity-App-Token')
      subject.headers.should have_key('Content-Type')
    end
  end

  describe "#body" do
    it "forms the correct id" do
      subject.body.should include("<id>1</id>")
    end

    it "forms the correct value" do
      subject.body.should include("<value>test_user</value>")
    end
  end

  describe "#url" do
    it "has a correct url" do
      subject.url.to_s.should include('customers/1/accounts/2/loginForm')
    end
  end
end
