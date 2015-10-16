require 'spec_helper'

describe ::Finicity::V2::Response::PartnerAuthentication do
  let(:sample_response) {
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><access><token>token-123</token></access>"
  }

  describe ".parse" do
    subject { described_class.parse(sample_response) }

    it "parses the token" do
      subject.token.should eq("token-123")
    end
  end
end
