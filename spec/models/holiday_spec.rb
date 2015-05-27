require 'rails_helper'

describe User do

  let(:holiday){ create :holiday }

  subject { holiday }

  it { should respond_to(:date) }

  describe "when date is not present" do
    before {holiday.date = nil }
    it { should_not be_valid }
  end
end
