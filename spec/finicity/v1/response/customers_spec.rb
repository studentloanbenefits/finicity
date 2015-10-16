require 'spec_helper'

describe ::Finicity::V1::Response::Customers do
  let(:sample_response) {
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><customers found=\"1\" displaying=\"1\" moreAvailable=\"false\"><customer><id>4079253</id><username>USR-fac55a4d-c690-5422-6b5c-096aae3c12f5</username><firstName>USR-fac55a4d-c690-5422-6b5c-096aae3c12f5</firstName><lastName>USR-fac55a4d-c690-5422-6b5c-096aae3c12f5</lastName><email>USR-fac55a4d-c690-5422-6b5c-096aae3c12f5@moneydesktop.com</email><createdDate>1410197285</createdDate></customer></customers>"
  }

  describe ".parse" do
    subject { described_class.parse(sample_response) }

    it "parses customer" do
      subject.customers.first.id.should eq("4079253")
    end

    it "parses displaying" do
      subject.displaying.should eq(1)
    end
  end
end
