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
      users, status, level, specialization = ["user_id", "status_id", "level_id", "specialization_id"].collect{|k| self[k] ? "#{k} = #{self[k]}" : ""}
      inform = Statistic.where(level).where(specialization).where(users).where(status).where(:week => date_start..date_end).sum(:count)
      self.percentage = inform.to_f / self.count * 100
      self.save
    end
  end 
end
