require 'spec_helper'

describe ::Finicity::V1::Response::Institutions do
  let(:sample_response) {
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><institutions found=\"52\" displaying=\"1\" moreAvailable=\"true\"><institution><id>5</id><name>Chase</name><accountTypeDescription>Banking</accountTypeDescription><totalAccounts>27158</totalAccounts><discovery>no</discovery><urlHomeApp>http://www.chase.com/</urlHomeApp><urlLogonApp>https://chaseonline.chase.com/chaseonline/logon/sso_logon.jsp</urlLogonApp></institution></institutions>"
  }

  describe ".parse" do
    subject { described_class.parse(sample_response) }

    it "parses institutions" do
      subject.institutions.size.should eq(1)
    end

    it "parses more_available" do
      subject.more_available?.should be true
    end
  end
end
