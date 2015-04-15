class Plan < Table
	def self.default_scope
    select(:id, :name, :date_start, :date_end, :type,
           :user_id, :status_id, :level_id,
           :specialization_id, :count, :percentage, :created_at,
           :updated_at)
  end

  def find_percentage
    if self.date_start and self.date_end
      date_start = self.date_start.at_beginning_of_week
      date_end = self.date_end.at_end_of_week
      inform = Statistic.where(level_id: self.level_id).where(specialization_id: self.specialization_id).where(user_id: self.user_id).where(status_id: self.status_id).where(:week => date_start..date_end).sum(:count)
      self.percentage = inform.to_f / count * 100
      self.save
    end
  end 
end
