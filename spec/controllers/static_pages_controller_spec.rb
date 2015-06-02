require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  describe 'GET #home' do
    let(:user) { create :user }
    
    it 'when logged out' do
      get :home
      expect(response.status).to eq(200)
    end

    it 'when logged in' do
      sign_in user
      get :home
      expect(response.status).to eq(200)
    end
  end
end
