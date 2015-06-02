require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let!(:user)             { create :user }
  let!(:no_permited_user) { create :user }
  let!(:permission)       { create :permission, name: 'self_reports' }
  let!(:user_permission)  { create :user_permission, user: user, permission: permission }
    
  describe 'User with permission self_report' do
    before :each do
      sign_in user
    end

    describe 'GET #index' do
      let!(:first_report)   { create(:report, user: user) }
      let!(:second_report)  { create(:report, user: user) }
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
        expect { post :create, format: 'js', report: attributes_for(:report, user: user) }
          .to change(Report, :count).by(1)
      end
   
      it 'render template create' do
        post :create,  format: 'js', report: attributes_for(:report, user: user)
        expect(response).to render_template(:create)
      end
    end

    describe 'PUT #update' do
      let!(:report) { create(:report, user: user) }
      let (:task)   { 'New task' }
      before do
        put :update, format: 'js',
        id: report,
        report: attributes_for(:report, task: task)
      end
      it 'update a new Report in the database' do
        report.reload
        expect(report.task).to eq(task)
      end
   
      it 'render template to update' do
        expect(response).to render_template(:update)
      end
    end

    describe 'GET #new' do
      it 'render template to new' do
        xhr :get, :new, format: 'js'
        expect(response).to render_template(:new)
      end
    end

    describe 'GET #destroy' do
      let!(:first_report)   { create(:report, user: user) }
      let!(:second_report)  { create(:report, user: user) }

      it 'destroy a Report in the database' do
        expect { delete :destroy, format: 'js', id: second_report  }
          .to change(Report, :count).by(-1)
      end
   
      it 'render template destroy' do
        delete :destroy,  format: 'js', id: first_report
        expect(response).to render_template(:destroy)
      end
    end
  end

  describe 'User without permission' do
    before :each do
      sign_in no_permited_user
    end

    describe 'GET #index' do
      let!(:first_report)   { create(:report, user: no_permited_user) }
      let!(:second_report)  { create(:report, user: no_permited_user) }
      before :each do
        get :index
      end
      
      it 'populate an array of all reports @reports' do
        expect(assigns(:reports)).to_not match_array([second_report, first_report])
      end

      it { expect(response.status).to eq(302) }
    end

    describe 'POST #create' do
      it 'create a new Report in the database' do
        expect { post :create, format: 'js', report: attributes_for(:report, user: no_permited_user) }
          .to change(Report, :count).by(0)
      end
   
      it 'render template create' do
        post :create,  format: 'js', report: attributes_for(:report, user: no_permited_user)
        expect(response).to redirect_to root_path
      end
    end

    describe 'PUT #update' do
      let!(:report) { create(:report) }
   
      it 'render template to update' do
        put :update, format: 'js',
        id: report,
        report: attributes_for(:report)
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #new' do
      it 'render template to new' do
        xhr :get, :new, format: 'js'
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #destroy' do
      let!(:first_report)   { create(:report) }
      let!(:second_report)  { create(:report) }

      it 'destroy a Report in the database' do
        expect { delete :destroy, format: 'js', id: second_report  }
          .to change(Report, :count).by(0)
      end
   
      it 'render template destroy' do
        delete :destroy,  format: 'js', id: first_report
        expect(response).to redirect_to root_path
      end
    end
  end

  # Here must be tested report_pointer method! 
end
