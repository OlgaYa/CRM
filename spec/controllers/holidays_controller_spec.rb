require 'rails_helper'

RSpec.describe HolidaysController, type: :controller do

  let(:user){ create :user }
  before :each do
    sign_in user
  end

  describe 'GET #index' do
    before :each do
      get :index
    end
    it { expect(response.status).to eq(200) }
  end
end
