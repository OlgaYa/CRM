module AdminHelper
  UNCHANGEABLESTATUS = ['sold', 'declined', 'negotiations', 'assigned_meeting']

  def get_new_user(user)
    if user
      user
    else
      User.new
    end
  end
  
  def get_users_control(user)
    if user.sign_in_count == 0 
      link_to(image_tag('remove.png'), user, data: {
          confirm: "Are you sure to remove user #{user.first_name} #{user.last_name}?"
        }, 
        method: :delete )
    else
      link_to(image_tag('edit.png'), user_path(user) + '#settings')
    end
  end

  def get_edit_link(path)
    link_to(image_tag('edit.png'), path)
  end

  def get_edit_for_task_controls(id)
    unless UNCHANGEABLESTATUS.include?(Status.find(id).name)
      image_tag('edit.png', class: 'edit')
    else
      image_tag('forbidden-icon.png', alt: "You can't remove it")
    end
  end

  def get_remove_link(path, id, field)
    flag = true if field == 'status_id' && UNCHANGEABLESTATUS.include?(Status.find(id).name)
    unless Task.exists?({field => id}) || flag
      link_to(image_tag('remove.png'), path, 
                        method: :delete, remote: true)
    else
      image_tag('forbidden-icon.png', alt: "You can't remove it")
    end
  end
end
