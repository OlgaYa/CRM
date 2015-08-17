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
    object.options_for_plan.where(option_type: type,
                                  status: "active")
  end

  def find_plan(type)
    plan = Plan.where("first_day_in_month = ? and for_type = ?", Date.today.at_beginning_of_month, type).first
    unless plan.present?
      plan = Plan.new
      plan.first_day_in_month = Date.current.beginning_of_month
    end
    graphics = []
    if plan
      date = plan.first_day_in_month
      graphics[0], graphics[1] = {}, {}
      graphics[0][:name], graphics[1][:name] = "plan", "current"
      array_plan, array_current = [], []
      days = Time.days_in_month(date.month, date.year)
      1.upto(days) do |i|
        array_plan[i-1] = plan.count.to_f/days * i
        current_day = Date.new(date.year, date.month, i)
        if current_day <= Date.today
          plan.id.present? ? array_current[i-1] = plan.count_in_current_day(current_day) : 
                             array_current[i-1] = plan.count_in_current_day(current_day, type)
          array_current[i-1] += array_current[i-2] if array_current[i-2]
        end
      end
      # graphics[0][:data], graphics[1][:data] = array_plan, array_current
      graphics[1][:data] = array_current
      graphics[0][:data] = array_plan if plan.id.present?
    end
    graphics.to_json
  end
end
