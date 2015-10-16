require 'spec_helper'

describe ::Finicity::V2::Request::PartnerAuthentication do
  describe "#body" do
    it "has a correct body" do
      subject.body.should include('partnerSecret')
    end
  end

  describe "#headers" do
    it "has correct headers" do
      subject.headers.should have_key('Finicity-App-Key')
    end
  end

  describe "#url" do
    it "has a correct url" do
      subject.url.to_s.should include('partners/authentication')
    end
  end
end
