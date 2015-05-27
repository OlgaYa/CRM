require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let(:user){ create :user }
  before :each do
    sign_in user
  end

  describe 'GET #index' do
    let!(:first_report){ create(:report, user: user) }
    let!(:second_report){ create(:report, user: user) }
    before :each do
      get :index
    end
    
    it 'populate an array of all reports @reports' do
      expect(assigns(:reports)).to match_array([second_report, first_report])
    end

    it { expect(response.status).to eq(200) }
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
    let!(:report) { create(:report, user: user) }
    let (:task) { 'New task' }
    before do
      put :update,
      id: report,
      report: attributes_for(:report, task: task)
    end
    it 'update a new Report in the database' do
      report.reload
      expect(report.task).to eq(task)
    end
 
    it 'redirects to reports#index' do
      expect(response).to redirect_to reports_path
    end
  end
end
