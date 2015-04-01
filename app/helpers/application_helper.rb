module ApplicationHelper

	include ActionView::Helpers::TagHelper
	include ActionView::Helpers::AssetTagHelper
	include ActionView::Helpers::UrlHelper
	attr_accessor :output_buffer

	def get_count_tasks(only = "")
		case only 
	    when 'sold'
	      Task.all.where("status = 'sold'").count.to_s
	    when 'declined'
	      Task.all.where("status = 'declined'").count.to_s
	    else
	      Task.all.where("status != 'sold' AND status != 'declined' OR status IS NULL").count.to_s
	    end
	end

	def user_status(user)
		if user.admin?
			return 'Admin'
		else
			return 'User'
		end
	end

	def current_user?(user)
		user == current_user
	end

	def generate_link(link) 
		content_tag(:div, class: "link l_#{link.id}") do
      buffer = ActiveSupport::SafeBuffer.new
      buffer << link_to(link.alt, link.href, target: '_blank')
      buffer << link_to(image_tag(ActionController::Base.helpers.asset_path("remove-red.png")), 
                      tasks_destroy_link_path(link), class: 'pull-right remove-link', 
                      method: :delete, remote: true)
      buffer
    end
	end

	def generate_tr_for_user(user)
		content_tag(:tr) do			
			buffer = ActiveSupport::SafeBuffer.new
			buffer << content_tag(:td, user.first_name)
			buffer << content_tag(:td, user.last_name)
			buffer << content_tag(:td, user.email)
			buffer << content_tag(:td, user_status(user))
			buffer << content_tag(:td, user.current_sign_in_at)
			buffer << content_tag(:td) do
			 	link_to(image_tag(ActionController::Base.helpers.asset_path("remove.png")), user_path(user), data: {
          confirm: "Are you sure to remove user #{user.first_name} #{user.last_name}?"
        }, 
        method: :delete )
			end
			buffer
		end
	end

	def generate_comment(comment, time)
		content_tag(:div, class: "comment c_#{comment.id}") do
			buffer = ActiveSupport::SafeBuffer.new
			buffer << image_tag(comment.user.avatar.url(:small), class: "pull-left comment-foto")
			buffer << content_tag(:span, time.strftime("%e.%m %H:%M"), class: 'comment_time')
			buffer << content_tag(:span, ' ' + comment.user.first_name, class: 'comment_time')
			if current_user == comment.user
				buffer << link_to(image_tag(ActionController::Base.helpers.asset_path("remove-red.png")), 
													comment_path(comment), class: 'pull-right', 
													method: :delete, remote: true)
			end
			buffer << content_tag(:p, comment.body)
			buffer << content_tag(:div,'', class: 'clear')
			buffer
		end
	end

	def header_add_task
		 if params[:controller] == 'tasks' && params[:action] == 'index' && !params[:only]
			form_for Task.new do |f|
				buffer = ActiveSupport::SafeBuffer.new
        buffer << f.text_field(:name, hidden: true) 
        buffer << f.submit("New task", class: "new btn btn-sm btn-primary")
        buffer 
      end 
    end
	end
end