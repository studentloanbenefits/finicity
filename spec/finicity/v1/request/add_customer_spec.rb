require 'spec_helper'

describe ::Finicity::V1::Request::AddCustomer do
  subject { described_class.new("token-123", "USR-123") }

  describe "#headers" do
    it "has correct headers" do
      subject.headers.should have_key('Finicity-App-Key')
      subject.headers.should have_key('Finicity-App-Token')
      subject.headers.should have_key('Content-Type')
    end
  end

  describe "#body" do
    it "includes username" do
      subject.body.should include('<username>USR-123</username>')
    end

    it "includes email" do
      subject.body.should include('<email>USR-123@mx.com</email>')
    end

    it "includes firstName" do
      subject.body.should include('<firstName>USR-123</firstName>')
    end

    it "includes lastName" do
      subject.body.should include('<lastName>USR-123</lastName>')
    end
  end

  describe "#url" do
    it "has a correct url" do
      subject.url.to_s.should include('customers/active')
    end
  end
end
