class StaticPagesController < ApplicationController
  def home
    user = current_user ? current_user : User.new
    permissions = user.permissions.pluck(:name)
    if permissions.include? 'manage_sales'
      redirect_to tables_path(type: 'SALE', only: 'open')
    elsif permissions.include? 'manage_candidates'
      redirect_to tables_path(type: 'CANDIDATE', only: 'open')
    elsif permissions.include? 'hr_admin'
      redirect_to admin_admin_pointer_path
    elsif permissions.include? 'self_reports'
      redirect_to summary_reports_path
    end
  end

  def baned_user
  end
end
