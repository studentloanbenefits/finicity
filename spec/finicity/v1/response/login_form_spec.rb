require 'spec_helper'

describe ::Finicity::V1::Response::LoginForm do
  let(:sample_response) {
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><loginForm><loginField><id>5001</id><name>usr_name</name><value></value><description>User ID</description><displayOrder>1</displayOrder><mask>false</mask><valueLengthMin>0</valueLengthMin><valueLengthMax>0</valueLengthMax></loginField><loginField><id>5002</id><name>usr_password</name><value></value><description>Password</description><displayOrder>2</displayOrder><mask>true</mask><valueLengthMin>0</valueLengthMin><valueLengthMax>0</valueLengthMax></loginField></loginForm>"
  }

  subject { described_class.parse(sample_response) }

  describe ".parse" do
    it "parses the login_fields" do
      subject.login_fields.size.should eq(2)
    end

    it "parses id" do
      subject.login_fields.first.id.should eq("5001")
    end

    it "parses name" do
      subject.login_fields.first.name.should eq("usr_name")
    end

    it "parses description" do
      subject.login_fields.first.description.should eq("User ID")
    end

    it "parses display_order" do
      subject.login_fields.first.display_order.should eq(1)
    end
  end
end
