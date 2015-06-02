# == Schema Information
#
# Table name: statistics
#
#  id                :integer          not null, primary key
#  statistic_id      :integer
#  for_type          :string
#  level_id          :integer
#  specialization_id :integer
#  source_id         :integer
#  week              :date
#  status_id         :integer
#  user_id           :integer
#  count             :integer          default(1)
#

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
                                  level_id: object.level_id,
                                  for_type: object.type,
                                  week: object.updated_at.to_date.at_beginning_of_week).first
    if information == nil
      information = Statistic.new(user_id: object.user_id,
                                  status_id: object.status_id,
                                  source_id: object.source_id,
                                  for_type: object.type,
                                  specialization_id: object.specialization_id,
                                  level_id: object.level_id,
                                  week: object.updated_at.to_date.at_beginning_of_week)
      information.save
    else
      information.count += 1
      information.save
    end
  end

  def self.find_record_with_same_information(current_object, params)
    unless current_object[params.keys[0]]
      Statistic.destroy(current_object)
    end
  end

  def self.destroy(object)
    Statistic.change_count(object, object.status_id)
    if object.status_id != Status.default_status(object.type.upcase)
      Statistic.change_count(object, Status.default_status(object.type.upcase))
    end
  end

  def self.change_count(object, status_id)
    information = Statistic.where(user_id: object.user_id,
                                  status_id: status_id,
                                  source_id: object.source_id,
                                  specialization_id: object.specialization_id,
                                  level_id: object.level_id,
                                  for_type: object.type,
                                  week: object.updated_at.to_date.at_beginning_of_week).first
    if information
      information.count -= 1
      information.count.zero? ? information.delete : information.save
    end
  end
end
