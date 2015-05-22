module ReportsHelper
  def generate_sortable_th_desc(class_names, name, value)
    content_tag(:th, sort_link(@q, value, name, default_order: :desc),  class: class_names)
  end
end
