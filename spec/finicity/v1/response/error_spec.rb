require 'spec_helper'

describe ::Finicity::V1::Response::Error do
  let(:sample_response) {
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><error><code>14006</code><message>Institution not found.</message></error>"
  }

  describe ".parse" do
    subject { described_class.parse(sample_response) }

    it "parses message" do
      subject.message.should eq("Institution not found.")
    end

    it "parses code" do
      subject.code.should eq(14006)
    end
  end
end
