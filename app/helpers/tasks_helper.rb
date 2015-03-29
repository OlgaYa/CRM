module TasksHelper
	def all_users
		User.all.order(:created_at)
	end

  def comments_for_table(comments)
  end

  def links_for_table(links)
    buffer = ActiveSupport::SafeBuffer.new
    links.each_with_index do |link, index|
      buffer << content_tag(:div, class: "link l_#{link.id}") do
        buffer_inner = ActiveSupport::SafeBuffer.new
        buffer_inner << link_to(link.alt, link.href, target: '_blank')
        buffer_inner << link_to(image_tag(ActionController::Base.helpers.asset_path("remove-red.png")), 
                        tasks_destroy_link_path(link), class: 'pull-right remove-link', 
                        method: :delete, remote: true)
        buffer_inner
      end
    end
    buffer
  end

  def messages_for_table(messages)

  end

  def full_user_name_for_table(user)
    
  end
end
