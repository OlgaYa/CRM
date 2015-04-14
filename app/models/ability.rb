class Ability
  include CanCan::Ability

  def initialize(user, params = '')
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      case user.role
      when 'seller'
        can :manage, Table
        cannot :manage, Table if params[:type] == 'CANDIDATE'
      when 'hh'
        can :manage, Table
        cannot :manage, Table if params[:type] == 'SALE'
      when 'hr'
      end
    end
  end
end
