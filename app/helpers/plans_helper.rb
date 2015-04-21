module PlansHelper

  def plan_users_fields
    case params[:type]
    when 'SALE'
      User.seller
    when 'CANDIDATE'
      User.hh
    end
  end

  def find_information_from_options(object, type)
    object.options_for_plan.where(option_type: type)
  end
end