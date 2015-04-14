# This class defines the essence of which users will be working with the role HH
class Candidate < Table
  def self.default_scope
    select(:id, :name, :level_id,
           :specialization_id,
           :email, :source_id,
           :date, :status_id,
           :type, :created_at,
           :updated_at)
  end
end
