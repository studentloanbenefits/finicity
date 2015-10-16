require 'spec_helper'

describe ::Finicity::V1::Request::GetInstitutions do
  subject { described_class.new("token-123", "Chase") }

  describe "#headers" do
    it "has correct headers" do
      subject.headers.should have_key('Finicity-App-Key')
      subject.headers.should have_key('Finicity-App-Token')
    end
  end

  describe "#url" do
    it "has a correct url" do
      subject.url.to_s.should include('institutions')
    end
  end
end
