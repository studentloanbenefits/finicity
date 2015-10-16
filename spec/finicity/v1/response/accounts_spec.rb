require 'spec_helper'

describe ::Finicity::V1::Response::Accounts do
  let(:sample_response) {
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><accounts><account><id>1234</id><number>1234</number><name>TOTAL CHECKING</name><balance>100</balance><type>checking</type><aggregationStatusCode>185</aggregationStatusCode><status>active</status><customerId>4079253</customerId><institutionId>5</institutionId><aggregationAttemptDate>1410378206</aggregationAttemptDate><createdDate>1410376928</createdDate></account><account><id>5678</id><number>5678</number><name>CHASE SAVINGS</name><balance>500</balance><type>savings</type><aggregationStatusCode>185</aggregationStatusCode><status>active</status><customerId>4079253</customerId><institutionId>5</institutionId><aggregationAttemptDate>1410378206</aggregationAttemptDate><createdDate>1410376928</createdDate></account></accounts>"
  }

  subject { described_class.parse(sample_response) }

  describe ".parse" do
    it "parses accounts" do
      subject.accounts.size.should eq(2)
    end

    it "parses account type" do
      subject.accounts.first.type.should eq("checking")
    end

    it "parses account name" do
      subject.accounts.first.name.should eq("TOTAL CHECKING")
    end

    it "parses account id" do
      subject.accounts.first.id.should eq("1234")
    end

    it "parses aggregation_status_code" do
      subject.accounts.first.aggregation_status_code.should eq(185)
    end
  end

  describe "#validate_aggregation_status!" do
    it "raises an error when the scrape_status_code indicates failure" do
      expect { subject.accounts.first.validate_aggregation_status! }.to raise_error(
        ::Finicity::InvalidCredentialsError
      )
    end
  end
end
