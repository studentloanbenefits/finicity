require 'spec_helper'

describe ::Finicity::V1::Request::GetCustomersByUsername do
  subject { described_class.new("token-123", "USR-123", 1, 25) }

  describe "#headers" do
    it "has correct headers" do
      subject.headers.should have_key('Finicity-App-Key')
      subject.headers.should have_key('Finicity-App-Token')
    end
  end

  describe "#url" do
    it "has a correct url" do
      subject.url.to_s.should include('customers')
    end
  end
end
