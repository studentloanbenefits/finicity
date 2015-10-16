require 'spec_helper'

describe ::Finicity::V1::Request::ActivateAccounts do
  let(:account) {
    instance_double(
      ::Finicity::V1::Response::Account,
      :id => 1,
      :number => 1234,
      :name => 'Account 1',
      :type => 'checking'
    )
  }
  let(:accounts) { [account] }

  subject { described_class.new("token-123", 1, 2, accounts) }

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

    it "forms the correct number" do
      subject.body.should include("<number>1234</number>")
    end

    it "forms the correct name" do
      subject.body.should include("<name>Account 1</name>")
    end

    it "forms the correct type" do
      subject.body.should include("<type>checking</type>")
    end
  end

  describe "#url" do
    it "has a correct url" do
      subject.url.to_s.should include('customers/1/institutions/2/accounts')
    end
  end
end
