class SoldTasksController < ApplicationController

	def update
		sold_task = SoldTask.find(params[:id])
		sold_task.update_attribute(params[:field].to_sym, params[:value])
		resp = "success".to_json
    	render :json => resp  
	end
end
