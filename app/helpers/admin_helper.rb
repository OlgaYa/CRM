module AdminHelper
  def get_users_control(user)
    if user.sign_in_count == 0
      link_to(image_tag('remove.png'), user,
              data: { confirm: "Are you want remove user #{user.full_name}?" },
              method: :delete)
    else
      link_to(image_tag('edit.png'), "#{user_path(user)}#settings")
    end
  end

  def get_edit_link(path)
    link_to(image_tag('edit.png'), path)
  end

  def get_edit_for_task_controls(id)
    case Status.find(id).unchengeble_satus?
    when false
      image_tag('edit.png', class: 'edit')
    when true
      image_tag('forbidden-icon.png', alt: "You can't remove it")
    end
  end

  def get_remove_link(path, id, field)
    case can_not_remove?(field, id)
    when false
      link_to(image_tag('remove.png'), path,
              method: :delete, remote: true)
    when true
      image_tag('forbidden-icon.png', alt: "You can't remove it")
    end
  end

  def can_not_remove?(field, id)
    (field == 'status_id' && Status.find(id).unchengeble_satus?) || Table.exists?({field => id})
  end  
end
