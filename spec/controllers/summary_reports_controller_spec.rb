require 'rails_helper'

RSpec.describe SummaryReportsController, type: :controller do
  let!(:permission)           { create :permission, name: 'summary_table_reports' }
  let!(:permission_self_rep)  { create :permission, name: 'self_reports' }
  let!(:user)                 { create :user }
  let!(:user_self_per)        { create :user }
  let!(:no_permited_user)     { create :user }
  let!(:user_self_rep_perm)   { create :user_permission, user: user, permission: permission }
  let!(:user_permission)      { create :user_permission, user: user_self_per, permission: permission_self_rep }
  let!(:reports)              { create :report, user: user_self_per }
    
  describe 'User with permission summary_table_reports' do
    
    before :each do
      sign_in user
    end

    describe 'GET #index' do
      it 'render template index' do
        get :index
        expect(response.status).to eq(200) 
      end
    end

    describe 'POST #refresh_dt' do
      it 'render json status' do
        post :refresh_dt,  format: 'js'
        expect(response).to be_success
      end
    end   
  end

  describe 'User without permission' do
    before :each do
      sign_in no_permited_user
    end

    describe 'GET #index' do
      before do
        get :index
      end
      it { expect(response).to redirect_to root_path }
    end

    describe 'POST #refresh_dt' do
      it 'render json status' do
        post :refresh_dt,  format: 'js'
        expect(response).to redirect_to root_path
      end
    end
  end
end
