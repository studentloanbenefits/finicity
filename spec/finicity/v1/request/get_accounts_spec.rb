require 'spec_helper'

describe ::Finicity::V1::Request::GetAccounts do
  subject { described_class.new("token-123", 1, 2) }

  describe "#headers" do
    it "has correct headers" do
      subject.headers.should have_key('Finicity-App-Key')
      subject.headers.should have_key('Finicity-App-Token')
    end
  end

  describe "#url" do
    it "has a correct url" do
      subject.url.to_s.should include('customers/1/institutions/2/accounts')
    end
  end
end
