require 'spec_helper'

describe ::Finicity::V1::Response::Mfa do
  let(:sample_response) {
    "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><mfaChallenges><questions><question><text>Would you like to get an Activation Code in your Email Account?</text><choice value=\"Yes\">Yes</choice><choice value=\"No\">No</choice></question></questions></mfaChallenges>"
  }

  describe ".parse" do
    subject { described_class.parse(sample_response) }

    it "parses questions" do
      subject.questions.size.should eq(1)
    end

    it "parses question text" do
      subject.questions.first.text.should eq("Would you like to get an Activation Code in your Email Account?")
    end

    it "parses choices" do
      subject.questions.first.choices.should eq(["Yes", "No"])
    end
  end
end
