require 'spec_helper'

describe ::Finicity::V1::Request::GetTransactions do
  subject { described_class.new("token-123", 1, 2, 100, 101) }

  describe "#headers" do
    it "has correct headers" do
      subject.headers.should have_key('Finicity-App-Key')
      subject.headers.should have_key('Finicity-App-Token')
      subject.headers.should have_key('Content-Type')
    end
  end

  describe "#url" do
    it "has a correct url" do
      subject.url.to_s.should include('customers/1/accounts/2/transactions')
    end
  end
end
