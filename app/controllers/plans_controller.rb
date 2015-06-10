class PlansController < ApplicationController
  load_and_authorize_resource
  
  def index
    Plan.all.each do |p|
      p.find_percentage
    end
    @plan_sale = Plan.where(for_type: 'SALE')
    @plan_candidate = Plan.where(for_type: 'CANDIDATE')
    paginate_plan_sale
    paginate_plan_candidate
  end

  def new
    @sale = 'SALE'
    @type = params[:type]
    @options = []
    @date = Date.today
  end

  def create
    date=Date.new(params[:date]['year'].to_i, params[:date]['month'].to_i, 1)
    plan = Plan.new(first_day_in_month: date,
                    count: params[:count],
                    for_type: params[:type])
    if plan.save
      [:statuses, :levels, :specializations].each do |p|
        create_option(p, plan)
      end
      redirect_to action: :index
    else
      redirect_to action: :new, :type => params[:type]
    end
  end

  def edit
    @sale = 'SALE'
    @type = params[:type]
    @plan = Plan.find(params[:id])
    @options = @plan.options_for_plan.where(status: "active").map{ |o| o.option }
    @date = @plan.first_day_in_month
  end

  def update
    date=Date.new(params[:date]['year'].to_i, params[:date]['month'].to_i, 1)
    plan = Plan.find(params[:id])
    plan.update_attributes(first_day_in_month: date,
                           count: params[:count],
                           for_type: params[:type])
    [:statuses, :levels, :specializations].each do |p|
      update_option(params[p], p, plan)
    end
    redirect_to action: :index
  end

  def destroy
    Plan.find(params[:id]).destroy
    redirect_to action: :index
  end

  private

    def create_option(parameter, plan)
      return unless params[parameter]
      params[parameter].each do |value|
        entity = to_entity(parameter)
        option = entity.find(value).options_for_plan.new(plan_id: plan.id)
        option.save
      end
    end

    def update_option(array, parameter, plan)
      return unless array
      type = parameter.to_s.singularize.capitalize
      plan.options_for_plan.where(option_type: type).each do |value|
        unless array.include? (value.option_id.to_s)
          value.update_attribute(:status, "inactive")
        else
          value.update_attribute(:status, "active")
          array.delete(value.option_id.to_s)
        end
      end
      array.each do |value|
        OptionsForPlan.create(plan_id: plan.id,
                              option_type: type,
                              option_id: value.to_i)
      end
    end

    def paginate_plan_sale
      @plan_sale = @plan_sale.paginate(page: params[:page],
                                       per_page: 5)
    end
    
    def paginate_plan_candidate
      @plan_candidate = @plan_candidate.paginate(page: params[:page],
                                                 per_page: 5)
    end

    def to_entity(parameter)
      parameter.to_s.singularize.capitalize.constantize
    end
end
