require 'spec_helper'

describe ::Finicity::V1::Request::GetLoginForm do
  subject { described_class.new("token-123", "institution-123") }

  describe "#headers" do
    it "has correct headers" do
      subject.headers.should have_key('Finicity-App-Key')
      subject.headers.should have_key('Finicity-App-Token')
    end
  end

  describe "#url" do
    it "has a correct url" do
      subject.url.to_s.should include('institution-123')
    end
  end
end
