module StatisticsHelper

  def array_select_field(type)
    case type
    when 'SALE'
      %w(status source)
    when 'CANDIDATE'
      %w(status source level specialization)
    end
  end

  def find_collect_for_select(type, name)
    case type
    when 'SALE'
      advanced?(name) ? entity(name).all_sale : entity(name).all
    when 'CANDIDATE'
      advanced?(name) ? entity(name).all_candidate : entity(name).all
    end
  end

  private

    def advanced?(name)
      name == 'status' || name == 'user' || name == 'source'
    end

    def entity(name)
      name.singularize.capitalize.constantize
    end
end
