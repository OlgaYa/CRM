# Here main generator for table view
module TablesHelper
  def table_generation(table)
    return if table.empty?
    buffer = ActiveSupport::SafeBuffer.new
    case table.first.type
    when 'Sale'
      buffer << generate_sale_table_head(table.first.status.name)
      buffer << generate_sale_table(table)
    when 'Candidate'
      buffer << generate_candidate_table(table)
    end
    buffer
  end

  # OPTIMIZE
  def generate_sale_table_head(name)
    content_tag(:tr, class: 'info') do
      concat content_tag(:th, 'Name')
      concat content_tag(:th, 'Topic')
      concat content_tag(:th, 'Source', class: 'sortable sort')
      concat content_tag(:th, 'Skype')
      concat content_tag(:th, 'Email')
      concat content_tag(:th, 'Links')
      concat content_tag(:th, 'Date', class: 'sort_desc sort')
      concat content_tag(:th, 'Assign to', class: 'sortable sort')
      concat content_tag(:th, 'Status', class: 'sortable sort')
      concat content_tag(:th, 'Price') if name == 'sold'
      concat content_tag(:th, 'Terms') if name == 'sold'
      concat content_tag(:th, 'Comments')
    end
  end

  def generate_sale_table(table)
    content_tag(:tbody) do
      table.each do |entity|
        concat generate_sale_row entity
      end
    end
  end

  def generate_candidate_table(table)
    content_tag(:tbody) do
      table.each do |entity|
        concat generate_candidate_row entity
      end
    end
  end

  def generate_sale_row(sale)
    content_tag(:tr, id: sale.id) do
      concat table_name sale.name
      concat table_topic sale.topic
      concat table_source sale.source_id
      concat table_skype sale.skype
      concat table_email sale.email
      concat table_links sale.links
      concat table_date sale.date
      concat table_user sale.user_id
      concat table_status sale.status_id
      concat table_price sale.price if sale.status.name == 'sold'
      concat table_period sale.date_start,
                          sale.date_end if sale.status.name == 'sold'
      concat table_comments sale.comments
    end
  end

  def generate_candidate_row(candidate)
    content_tag(:tr, id: candidate.id) do
      concat table_name candidate.name
      concat table_level candidate.level_id
      concat table_specialization candidate.specialization_id
      concat table_email candidate.email
      concat table_source candidate.source_id
      concat table_date candidate.date
      concat table_status candidate.status_id
    end
  end

  def table_name(name)
    content_tag(:td, name,
                class: 'editable-field td-name',
                name: 'table[name]', value: 'name')
  end

  def table_level(level_id)
    content_tag(:td, '', class: 'td-level-id') do
      select_field(:table, :level_id,
                   Level.all.collect { |l| [l.name.capitalize, l.id] },
                   level_id)
    end
  end

  def table_specialization(specialization_id)
    content_tag(:td, '', class: 'td-specialization-id') do
      select_field(:table, :specialization_id,
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
      select_field(:table, :source_id,
                   Source.all.collect { |s| [s.name.capitalize, s.id] },
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
      select_field(:table, :status_id,
                   Status.all.collect { |s| [s.name.capitalize, s.id] },
                   status_id)
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
                   User.all.collect { |s| [s.full_name, s.id] }, user_id)
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
    content_tag(:td, '', class: 'td-links', value: 'links') do
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
                     '',
                     class: 'pull-right remove-link',
                     method: :delete, remote: true)
    end
  end

  def table_comments(comments)
    content_tag(:td, class: 'td-comments') do
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
end
