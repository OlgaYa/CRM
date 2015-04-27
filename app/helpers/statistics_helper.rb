module StatisticsHelper

	def array_select_field(type)
		case type
		when "SALE"
			["status", "source"]
		when "CANDIDATE"
		  ["status", "source", "level", "specialization"]
		end
	end

	def find_collect_for_select(type, name)
		case type
		when "SALE"
			(name == "status" or name == "user" or name == "source") ? name.singularize.capitalize.constantize.all_sale : name.singularize.capitalize.constantize.all
		when "CANDIDATE"
			(name == "status" or name == "user" or name == "source") ? name.singularize.capitalize.constantize.all_candidate : name.singularize.capitalize.constantize.all
		end	
	end
end