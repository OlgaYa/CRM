# Here main generator for table view
module TablesHelper
  EXPORT_FIELDS_SALE = { name: :name,
                         email: :email,
                         source: :source_id,
                         date: :date,
                         status: :status_id,
                         topic: :topic,
                         skype: :skype,
                         user: :user_id }

  DEFAULT_SORT = 'date:desc,user_id,status_id'

  def export_field
    case params[:type]
    when 'SALE'
      export_fields_sale
    when 'CANDIDATE'
      export_field_candidate
    end
  end

  def export_fields_sale
    content_tag(:td, '', id: 'fields') do
      buffer = ActiveSupport::SafeBuffer.new
      EXPORT_FIELDS_SALE.each do |key, value|
        buffer << check_box_tag(key, key, false, name: 'fields[]', value: value)
        buffer << label_tag(key)
        buffer << tag(:br)
      end
      buffer
    end
  end

  # NEED WRITE
  def export_field_candidate
  end

  def export_users_fields
    case params[:type]
    when 'SALE'
      User.seller
    when 'CANDIDATE'
      User.hh
    end
  end

  def table_generation(table)
    return if table.empty?
    buffer = ActiveSupport::SafeBuffer.new
    case table.first.type
    when 'Sale'
      buffer << generate_sale_table_head(table.first.status.name)
      buffer << generate_sale_table(table)
    when 'Candidate'
      buffer << generate_candidate_table_head(table.first.status.name)
      buffer << generate_candidate_table(table)
    when 'Plan'
      buffer << generate_plan_table_head("")
      buffer << generate_plan_table(table)
    end
    buffer
  end

  # OPTIMIZE
  def generate_sale_table_head(name)
    content_tag(:thead) do
      content_tag(:tr, class: 'info') do
        concat content_tag(:th, '#')
        concat content_tag(:th, 'Name')
        concat content_tag(:th, 'Topic')
        concat generate_sortable_th('sort', 'Source', :source_id)
        concat content_tag(:th, 'Skype')
        concat content_tag(:th, 'Email')
        concat content_tag(:th, 'Links')
        concat generate_sortable_th('sort', 'Date', :date)
        concat generate_sortable_th('sort', 'Assign to', :user_id)
        concat generate_sortable_th('sort', 'Status', :status_id)
        concat content_tag(:th, 'Price') if name == 'sold'
        concat content_tag(:th, 'Terms') if name == 'sold'
        concat content_tag(:th, 'Comments')
      end
    end
  end

  def generate_candidate_table_head(name)
    content_tag(:thead) do
      content_tag(:tr, class: 'info') do
        concat content_tag(:th, '#')
        concat content_tag(:th, 'Name')
        concat generate_sortable_th('sort', 'Level', :level_id)
        concat generate_sortable_th('sort', 'Specialization', :specialization_id)
        concat content_tag(:th, 'Email')
        concat generate_sortable_th('sort', 'Source', :source_id)
        concat content_tag(:th, 'Links')
        concat generate_sortable_th('sort', 'Date', :date)
        concat generate_sortable_th('sort', 'Status', :status_id)
        concat content_tag(:th, 'Reminder') if name == 'contact_later'
        concat content_tag(:th, 'Comments')
      end
    end
  end

  def generate_plan_table_head(name)
    content_tag(:thead) do
      content_tag(:tr, class: 'info') do
        concat content_tag(:th, '#')
        concat content_tag(:th, 'Name')
        concat generate_sortable_th('sort', 'User', :user_id)
        concat generate_sortable_th('sort', 'Level', :level_id)
        concat generate_sortable_th('sort', 'Specialization', :specialization_id)
        concat generate_sortable_th('sort', 'Status', :status_id)
        concat content_tag(:th, 'Data')
        concat content_tag(:th, 'Count')
        concat content_tag(:th, 'Percentage, %')
      end
    end
  end

  def generate_sortable_th(class_names, name, value)
    content_tag(:th, sort_link(@q, value, name),  class: class_names)
  end

  def generate_sale_table(table)
    content_tag(:tbody, class: 'table-body') do
      table.each do |entity|
        concat generate_sale_row entity
      end
    end
  end

  def generate_candidate_table(table)
    content_tag(:tbody, class: 'table-body') do
      table.each do |entity|
        concat generate_candidate_row entity
      end
    end
  end

  def generate_plan_table(table)
    content_tag(:tbody, class: 'table-body') do
      table.each do |entity|
        concat generate_plan_row entity
      end
    end
  end

  def generate_plan_row(plan)
    content_tag(:tr, id: plan.id) do
      concat table_control plan.id
      concat table_name plan.name
      concat table_user plan.user_id
      concat table_level plan.level_id
      concat table_specialization plan.specialization_id
      concat table_status plan.status
      concat table_period plan.date_start,
                          plan.date_end
      concat table_count plan.count
      concat table_percentage plan.percentage
    end
  end

  def generate_sale_row(sale)
    content_tag(:tr, id: sale.id) do
      concat table_control sale.id
      concat table_name sale.name
      concat table_topic sale.topic
      concat table_source sale.source_id
      concat table_skype sale.skype
      concat table_email sale.email
      concat table_links sale.links
      concat table_date sale.date
      concat table_user sale.user_id
      concat table_status sale.status_id
      concat table_price sale.price if sale.status.sold?
      concat table_period sale.date_start,
                          sale.date_end if sale.status.sold?
      concat table_comments sale.comments
    end
  end

  def generate_candidate_row(candidate)
    content_tag(:tr, id: candidate.id) do
      concat table_control candidate.id
      concat table_name candidate.name
      concat table_level candidate.level_id
      concat table_specialization candidate.specialization_id
      concat table_email candidate.email
      concat table_source candidate.source_id
      concat table_links candidate.links
      concat table_date candidate.date
      concat table_status candidate.status_id
      concat table_reminder candidate.reminder_date if candidate.status.contact_later?
      concat table_comments candidate.comments
    end
  end

  def table_control(id)
    content_tag(:td, '', class: 'controlls') do
      name = 'row' + id.to_s
      check_box_tag(name, id, false, class: 'controll')
    end
  end

  def table_reminder(date_time)
    content_tag(:td, date_time,
                class: 'date-time-editable td-reminder',
                name: 'table[reminder_date]', value: 'reminder_date')
  end


  def table_name(name)
    content_tag(:td, name,
                class: 'editable-field td-name',
                name: 'table[name]', value: 'name')
  end

  def table_count(count)
    content_tag(:td, count,
                class: 'editable-field td-count',
                name: 'table[count]', value: 'count')
  end

  def table_percentage(percentage)
    content_tag(:td, percentage,
                class: 'editable-field td-percentage',
                name: 'table[percentage]', value: 'percentage')
  end

  def table_level(level_id)
    content_tag(:td, '', class: 'td-level-id') do
      select_field_with_no_selected(:table, :level_id,
                   Level.all.collect { |l| [l.name.capitalize, l.id] },
                   level_id)
    end
  end

  def table_specialization(specialization_id)
    content_tag(:td, '', class: 'td-specialization-id') do
      select_field_with_no_selected(:table, :specialization_id,
                   Specialization.all.collect { |s| [s.name.capitalize, s.id] },
                   specialization_id)
    end
  end

  def table_email(email)
    content_tag(:td, email,
                class: 'editable-field td-email',
                name: 'table[email]',
                value: 'email')
  end

  def table_source(source_id)
    content_tag(:td, '', class: 'td-source-id') do
      select_field_with_no_selected(:table, :source_id,
                   Source.all.where(for_type: params[:type].downcase).collect { |s| [s.name.capitalize, s.id] },
                   source_id)
    end
  end

  def table_date(date)
    content_tag(:td, '', class: 'td-date') do
      content_tag(:input, '',
                  name: 'table[date]',
                  value: date, class: 'date-input')
    end
  end

  def table_status(status_id)
    content_tag(:td, '', class: 'td-status-id') do
      case params[:type]
      when 'PLAN'
        select_field_with_no_selected(:table, :status_id,
                   Status.all.collect { |s| [s.name.capitalize, s.id] },
                   status_id)
      else
        select_field(:table, :status_id,
                   Status.all.where(for_type: params[:type].downcase).collect { |s| [s.name.capitalize, s.id] },
                   status_id)
      end
    end
  end

  def table_topic(topic)
    content_tag(:td, topic,
                class: 'editable-field td-topic',
                name: 'table[topic]',
                value: 'topic')
  end

  def table_user(user_id)
    content_tag(:td, '', class: 'td-user-id') do
      select_field(:table, :user_id,
                   users.collect { |s| [s.full_name, s.id] }, user_id)
    end
  end

  def users
    case params[:type]
    when 'SALE'
      User.seller
    when 'CANDIDATE'
      User.hh
    when 'PLAN'
      User.all
    end
  end

  def table_price(price)
    content_tag(:td, price,
                class: 'editable-field td-price',
                name: 'table[price]',
                value: 'price')
  end

  def table_skype(skype)
    content_tag(:td, skype,
                class: 'editable-field td-skype ',
                name: 'table[skype]',
                value: 'skype')
  end

  def table_period(date_start, date_end)
    content_tag(:td, '', class: 'td-period') do
      concat content_tag(:label, 'Start:')
      concat content_tag(:input, '',
                         name: 'table[date_start]',
                         class: 'date-input period-date-start',
                         value: date_start)
      concat content_tag(:label, 'End:')
      concat content_tag(:input, '',
                         name: 'table[date_end]',
                         class: 'date-input period-date-end',
                         value: date_end)
    end
  end

  def table_links(links)
    content_tag(:td, '', class: 'editable-activity td-links', value: 'links') do
      content_tag(:div, class: 'link_list') do
        links.each do |link|
          concat generate_link(link)
        end
      end
    end
  end

  # FIXME
  def generate_link(link)
    content_tag(:div, class: "link l_#{link.id}") do
      concat link_to(link.alt, link.href, target: '_blank')
      concat link_to(image_tag(ActionController::Base.helpers
                     .asset_path('remove-red.png')),
                     link_path(link),
                     class: 'pull-right remove-link',
                     method: :delete, remote: true)
    end
  end

  def table_comments(comments)
    content_tag(:td,
                class: 'editable-activity td-comments',
                value: 'comments') do
      content_tag(:div, class: 'comment_list') do
        comments.each do |comment|
          concat generate_comment(comment)
        end
      end
    end
  end

  def generate_comment(comment)
    content_tag(:div, class: "comment c_#{comment.id}") do
      concat comment_topic(comment)
      concat link_remove_comment(comment)
      concat content_tag(:p, comment.body)
      concat content_tag(:div, '', class: 'clear')
    end
  end

  def comment_topic(comment)
    buffer = ActiveSupport::SafeBuffer.new
    buffer << img_field(comment.user.avatar.url(:small),
                        'pull-left comment-foto')
    buffer << span_field(comment.datetime.strftime('%e.%m %H:%M'),
                         'comment_time')
    buffer << span_field(' ' + comment.user.first_name, 'comment_time')
    buffer
  end

  def link_remove_comment(comment)
    return unless current_user == comment.user
    link_to(img_field('remove-red.png'),
            comment_path(comment),
            class: 'pull-right', method: :delete, remote: true)
  end

  def span_field(value, class_names = '')
    content_tag(:span, value, class: class_names)
  end

  def img_field(url, class_names = '')
    image_tag(url, class: class_names)
  end

  def select_field(field_name_1,
                   field_name_2,
                   collenction,
                   selected_field,
                   class_names = '')
    select(field_name_1, field_name_2,
           collenction, { selected: selected_field },
           class: class_names + 'selectable-field btn btn-default',
           fieldname: field_name_2)
  end

  def select_field_with_no_selected(field_name_1,
                                    field_name_2,
                                    collenction,
                                    selected_field,
                                    class_names = '')
    select(field_name_1, field_name_2,
           collenction, { include_blank: "Not selected", selected: selected_field },
           class: class_names + 'selectable-field btn btn-default',
           fieldname: field_name_2)
  end
end
