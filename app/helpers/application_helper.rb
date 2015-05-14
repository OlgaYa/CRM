module ApplicationHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::UrlHelper
  attr_accessor :output_buffer

  def user_status(user)
    if user.admin?
      return 'Admin'
    else
      return user.role
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
                      link_path(link), class: 'pull-right remove-link',
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
      buffer << image_tag(comment.user.avatar.url(:small), class: 'pull-left comment-foto')
      buffer << content_tag(:span, time.strftime("%e.%m %H:%M"), class: 'comment_time')
      buffer << content_tag(:span, ' ' + comment.user.first_name, class: 'comment_time')
      if current_user == comment.user
        buffer << link_to(image_tag(ActionController::Base.helpers.asset_path('remove-red.png')),
                          comment_path(comment), class: 'pull-right',
                          method: :delete, remote: true)
      end
      buffer << content_tag(:p, comment.body)
      buffer << content_tag(:div,'', class: 'clear')
      buffer
    end
  end

  def generate_header_menu
    role = current_user.role if current_user
    role = 'admin' if current_user && current_user.admin?
    content_tag(:nav,
                class: 'navbar navbar-default navbar-fixed-top',
                role: 'navigation') do
      content_tag(:div, class: 'container-fluid') do
        buffer = ActiveSupport::SafeBuffer.new
        buffer << generate_logo
        buffer << content_tag(:div,
                              class: 'collapse navbar-collapse',
                              id: 'main-navbar-collapse') do
          concat generate_left_menu(role)
          concat generate_right_menu
        end
        buffer
      end
    end
  end

  def generate_logo
    content_tag(:div, class: 'navbar-header') do
      buffer = ActiveSupport::SafeBuffer.new
      buffer << content_tag(:button, type: 'button',  class: 'navbar-toggle', data: { toggle: 'collapse', target:'#main-navbar-collapse' }) do
        buffer_inner = ActiveSupport::SafeBuffer.new
        4.times do
          buffer_inner << content_tag(:span, '', class: 'icon-bar')
        end
        buffer_inner
      end
      buffer << link_to('CRM', root_url, class: 'navbar-brand')
      buffer
    end
  end

  def generate_left_menu(role)
    menu = YAML.load_file("#{Rails.root.to_s}/config/menu.yml")
    content_tag(:ul, class: 'nav navbar-nav') do
      buffer = ActiveSupport::SafeBuffer.new
      menu['roles'].each do |role|
        if current_user && (current_user.role == role[0] || current_user.admin)
          buffer << content_tag(:li) do
            link_to(role[1]['name'], role[1]['path_table'])
          end
        end
      end
      if menu[role.to_s]
        menu[role.to_s]['menu'].each do |sub_menu|
          buffer << get_dropdown(sub_menu)
        end
      end
      buffer
    end
  end

  def get_dropdown(sub_menu, image = nil, id = nil)
    content_tag(:li, class: 'dropdown', id: id) do
      concat get_toggle_link(sub_menu[1]['name'], image)
      concat get_dropdown_menu(sub_menu)
    end
  end

  def get_toggle_link(name, image)
    link_to('#', class: 'dropdown-toggle', data: { toggle:'dropdown' }) do
      concat name
      concat content_tag(:b, '', class: 'caret') unless image
      concat image if image
    end
  end

  def get_dropdown_menu(sub_menu)
    content_tag(:ul, class: 'dropdown-menu') do
      sub_menu[1].each do |item|
        topic = item[0]
        concat get_dropdown_menu_link(item) if topic != 'name' && !item[1]['divider']
        concat get_divider if item[1]['divider']
      end
    end
  end

  def get_dropdown_menu_link(item)
    content_tag(:li) do
      if item[1]['name'] == 'Sign out'
        link_to(item[1]['name'], item[1]['path'], method: :delete)
      else
        link_to(item[1]['name'], item[1]['path'])
      end
    end
  end

  def get_divider
    content_tag(:li,'', class: 'divider')
  end

  def generate_right_menu
    content_tag(:ul, class: 'nav navbar-nav navbar-right') do
      if current_user
        generate_right_sub_menu
      else
        generate_log_in
      end
    end
  end

  def generate_right_sub_sub_menu
    buffer = ActiveSupport::SafeBuffer.new
    menu = YAML.load_file("#{Rails.root.to_s}/config/menu.yml")
    if current_user.admin || current_user.role == 'hh'
          buffer << content_tag(:li) do
            link_to('Text for interview', '/admin/email_texts/interview_text')
          end
    end
    if current_user.admin || current_user.role == 'seller'
          buffer << content_tag(:li) do
            link_to('Export', '/export?type=SALE')
          end
    end
    if current_user.admin
      sub_menu_meeting = [ 'sub_menu', {'name' => 'Meeting',
        "item one" => {'name' => 'Meeting seller', 'path' => menu['roles']['seller']['path_meeting']},
        "item two" => {'name' => 'Meeting HH', 'path' => menu['roles']['hh']['path_meeting']}
        }]
      buffer << get_dropdown(sub_menu_meeting, nil, 'sub_menu_meeting')
      sub_menu_stat = [ 'sub_menu', {'name' => 'Statistics',
        "item one" => {'name' => 'Statistics seller', 'path' => menu['roles']['seller']['path_statistics'] },
        "item two" => {'name' => 'Statistics HH', 'path' => menu['roles']['hh']['path_statistics'] }
        }]
      buffer << get_dropdown(sub_menu_stat, nil, 'sub_menu_stat')
    else
      menu['roles'].each do |role|
        if current_user && (current_user.role == role[0])
          buffer << content_tag(:li) do
            link_to('Meeting', role[1]['path_meeting'])
          end
          buffer << content_tag(:li) do
            link_to('Statistics', role[1]['path_statistics'])
          end
        end
      end
    end
    buffer
  end

  def generate_right_sub_menu
    image = get_avatar
    get_dropdown(get_current_user_sub_menu, image)
  end

  def generate_log_in
    content_tag(:li) do
      link_to("Log in", new_user_session_path)
    end
  end

  def get_current_user_sub_menu
    result = ['sub menu', { 'name'=>current_user.first_name,
                            "item one"=>{ "name"=>"Profile", "path"=> user_path(current_user.id) },
                            "item dev one"=>{ "divider"=>true },
                            "item two"=>{ "name"=>"Sign out", "path"=> destroy_user_session_path } }]
  end

  def get_avatar
    # content_tag(:li) do
      image_tag(current_user.avatar.url, class: 'avatar-small')
    # end
  end
end
