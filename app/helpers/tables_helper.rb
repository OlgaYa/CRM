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

  def generate_sale_table_head(name)
    buffer = ActiveSupport::SafeBuffer.new
    buffer << content_tag(:th, 'Name')
    buffer << content_tag(:th, 'Topic')
    buffer << content_tag(:th, 'Source')
    buffer << content_tag(:th, 'Skype')
    buffer << content_tag(:th, 'Email')
    buffer << content_tag(:th, 'Date')
    buffer << content_tag(:th, 'Assign to')
    buffer << content_tag(:th, 'Status')
    buffer << content_tag(:th, 'Price') if name == 'sold'
    buffer << content_tag(:th, 'Terms') if name == 'sold'
    buffer << content_tag(:th, 'Comments')
    buffer
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
      concat table_date sale.date
      concat table_user sale.user_id
      concat table_status sale.status_id
      concat table_price sale.price if sale.status.name == 'sold'
      concat table_period sale.date_start,
                          sale.date_end if sale.status.name == 'sold'
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
    content_tag(:td, name, class: 'editable-field', name: 'table[name]')
  end

  def table_level(level_id)
    content_tag(:td) do
      select(:table, :level_id,
             Level.all.collect { |l| [l.name.capitalize, l.id] },
             selected: level_id, class: 'selectable-field')
    end
  end

  def table_specialization(specialization_id)
    content_tag(:td) do
      select(:table, :specialization_id,
             Specialization.all.collect { |s| [s.name.capitalize, s.id] },
             selected: specialization_id, class: 'selectable-field')
    end
  end

  def table_email(email)
    content_tag(:td, email, class: 'editable-field', name: 'table[email]')
  end

  def table_source(source_id)
    content_tag(:td) do
      select(:table, :source_id,
             Source.all.collect { |s| [s.name.capitalize, s.id] },
             selected: source_id, class: 'selectable-field')
    end
  end

  def table_date(date)
    content_tag(:td) do
      tag(:input, date, name: 'table[date]', class: 'date-input')
    end
  end

  def table_status(status_id)
    content_tag(:td) do
      select(:table, :status_id,
             Status.all.collect { |s| [s.name.capitalize, s.id] },
             selected: status_id, class: 'selectable-field')
    end
  end

  def table_topic(topic)
    content_tag(:td, topic, class: 'editable-field', name: 'table[topic]')
  end

  def table_user(user_id)
    content_tag(:td) do
      select(:table, :user_id,
             User.all.collect { |s| [s.full_name, s.id] },
             selected: user_id, class: 'selectable-field')
    end
  end

  def table_price(price)
    content_tag(:td, price, class: 'editable-field')
  end

  def table_skype(skype)
    content_tag(:td, skype, class: 'editable-field', name: 'table[skype]')
  end

  def table_period(date_start, date_end)
    content_tag(:td) do
      concat tag(:input, date_start,
                 name: 'table[date_start]', class: 'date-input')
      concat tag(:input, date_end,
                 name: 'table[date_end]', class: 'date-input')
    end
  end
end
