require 'rails_helper'
describe User do

  let(:user){ create :user }

  subject { user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  describe "when first_name is not present" do
    before { user.first_name = " " }
    it { should_not be_valid }
  end

  describe "when last_name is not present" do
    before { user.last_name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { user.email = " " }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { user.password = user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { user.password = user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "remider about table" do
    let(:user_2){ create :user }
    let!(:older_table) do
      FactoryGirl.create(:table, user: user, updated_at: 3.day.ago)
    end
    let!(:newer_table) do
      FactoryGirl.create(:table, user: user_2, updated_at: 1.hour.ago)
    end

    before do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.deliveries = []
    end

    it 'send mail' do
      User.reminder
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
    # Чистим очередь:
    ActionMailer::Base.deliveries.clear
  end
end
