class Ability
  include CanCan::Ability

  def initialize(user, params = {})
    user ||= User.new
    perm = user.permissions.pluck(:name)
    if perm.include? 'administrate_all'
      can :manage, :all
    else
      # Permission for HH or sales admin room
      if (perm.include?('manage_seller_controls') && params[:type] == 'SALE') ||
         (perm.include?('manage_hh_controls') && params[:type] == 'CANDIDATE')
        can :task_controls, :admin
        
        can [:create_source,
             :destroy_source,
             :update_source], :admin
        
        can [:create_status,
             :destroy_status,
             :update_status], :admin
        
        can [:create_level,
             :destroy_level,
             :update_level], :admin

        can [:create_specialization,
             :destroy_specialization,
             :update_specialization], :admin
      end

      if perm.include?('manage_seller_controls') ||
         perm.include?('manage_hh_controls')
        can :admin_pointer, :admin
      end

      # Table HH pr Sales full permission
      if (perm.include?('manage_sales') && params[:type] == 'SALE') ||
         (perm.include?('manage_candidates') && params[:type] == 'CANDIDATE')
        # Comment controller
        can :create, Comment
        can :destroy, Comment, user_id: user.id

        # Histories controller
        can :index, History

        # Meetings controller
        can :index, Meeting
        can [:create, :edit, :update, :destroy], Meeting

        # Statistics controller
        can [:index, :change_information], Statistic

        # Tables controller
        can :index, Table
        can [:create, :update], Table
        can :destroy, Table


        can [:table_settings,
             :update_table_settings], :table

        can [:destroy_link, :create_link], :table

        can [:export,
             :download_selective_xls,
             :download_scoped_xls], :table
      end

      # Full permission for crm controls
      if perm.include?('crm_controls_admin')
        # Plans controller
        can :index, Plan
        can [:new, :create], Plan

        # Users controller
        can :show, User
        can [:edit, :update], User
        can :destroy, User

        # Admin controller
        can :admin_pointer, :admin
        can :show_users, :admin
        can :update_user_status, :admin
      end

      if perm.include?('summary_table_reports')
        can :manage, :summary_report
      end

      if perm.include?('self_reports')
        can :index, Report
        can [:edit, :update, :create, :destroy], Report, user_id: user.id
      end
    end
  end
end
