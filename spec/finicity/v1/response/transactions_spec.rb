require 'spec_helper'

describe ::Finicity::V1::Response::Transactions do
  let(:sample_response) {
     "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><transactions><transaction><amount>-6.5</amount><bonusAmount>0.0</bonusAmount><accountId>5159222</accountId><customerId>4079253</customerId><createdDate>1410385477</createdDate><description>JUICE N JAVA OREM OREM UT</description><escrowAmount>0.0</escrowAmount><feeAmount>0.0</feeAmount><id>409296552</id><institutionTransactionId>201409080</institutionTransactionId><interestAmount>0.0</interestAmount><memo>09/04</memo><postedDate>1410199200</postedDate><principalAmount>0.0</principalAmount><status>active</status><unitQuantity>0.0</unitQuantity><unitValue>0.0</unitValue></transaction></transactions>"
  }

  describe ".parse" do
    subject { described_class.parse(sample_response) }

    it "parses transactions" do
      subject.transactions.size.should eq(1)
    end

    it "parses id" do
      subject.transactions.first.id.should eq("409296552")
    end

    it "parses amount" do
      subject.transactions.first.amount.should eq(-6.5)
    end

    it "parses account_id" do
      subject.transactions.first.account_id.should eq("5159222")
    end

    it "parses customer_id" do
      subject.transactions.first.customer_id.should eq("4079253")
    end

    it "parses description" do
      subject.transactions.first.description.should eq("JUICE N JAVA OREM OREM UT")
    end

    it "parses memo" do
      subject.transactions.first.memo.should eq("09/04")
    end

    it "parses posted_date" do
      subject.transactions.first.posted_date.should eq(1410199200)
    end

    it "parses status" do
      subject.transactions.first.status.should eq("active")
    end
  end
end
