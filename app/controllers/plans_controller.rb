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
  end

  def create
    plan = Plan.new(date_from: params[:dateFrom],
                    date_to: params[:dateTo],
                    count: params[:count],
                    for_type: params[:type])
    if plan.save
      %i(users statuses levels specializations).each do |p|
        create_option(p, plan)
      end
      redirect_to action: :index
    else
      render 'new'
    end
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
