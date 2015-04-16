class Statistic < ActiveRecord::Base
  belongs_to :source
  belongs_to :status
  belongs_to :specializations
  belongs_to :levels
  belongs_to :user

  def self.update_statistics (object)
    information = Statistic.where(user_id: object.user_id,
                                  status_id: object.status_id,
                                  source_id: object.source_id,
                                  specialization_id: object.specialization_id,
                                  for_type: object.type,
                                  week: object.updated_at.at_beginning_of_week).first
    if information == nil
      information = Statistic.new(user_id: object.user_id,
                                  status_id: object.status_id,
                                  source_id: object.source_id,
                                  for_type: object.type,
                                  week: object.updated_at.at_beginning_of_week)
      information.save
    else
      information.count += 1
      information.save
    end
  end
end
