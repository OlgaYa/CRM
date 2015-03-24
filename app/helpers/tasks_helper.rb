module TasksHelper
	def all_users
		User.all.order(:created_at)
	end

  def get_links(link_string)
    buffer = ActiveSupport::SafeBuffer.new
    arr = link_string.split(' ')
    count = arr.length
    arr.each_with_index do |link, index| 
      buffer << link_to(link.match(/[a-z0-9]*(\.?[a-z0-9]+)\.[a-z]{2,5}(:[0-9]{1,5})?(.\/)?/), link, target: '_blank')
      if index != count-1
        buffer << tag(:br)
      end
    end
    buffer
  end
end
