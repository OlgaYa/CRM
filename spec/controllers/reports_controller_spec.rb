require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let!(:user){ create :user }
  before :each do
    sign_in user
  end

  describe 'GET #index' do
    let!(:first_report){ FactoryGirl.create(:report, user: user)}
    let!(:second_report){ FactoryGirl.create(:report, user: user)} 
    
    
    it 'populate an array of all reports @reports' do
      get :index
      expect(assigns(:reports)).to match_array([second_report, first_report])
    end

    it 'have a positive responce status 200' do
      get :index
      expect(response.status).to eq(200)
    end

  end

  describe 'POST #create' do
    it 'create a new Report in the database' do
      expect { post :create, report: attributes_for(:report) }
        .to change(Report, :count).by(1)
    end
 
    it 'redirects to companies#index' do
      post :create, report: attributes_for(:report)
      expect(response).to redirect_to reports_path
    end
  end
  describe 'PUT #update' do
    let!(:report) { FactoryGirl.create(:report, user: user) }
    it 'update a new Report in the database' do
      put :update,
          id: report,
          report: attributes_for(:report, task: 'New task')
      report.reload
      expect(report.task).to eq('New task')
    end
 
    it 'redirects to reports#index' do
      put :update,
          id: report,
          report: attributes_for(:report, task: 'New task')
      expect(response).to redirect_to reports_path
    end
  end
end
