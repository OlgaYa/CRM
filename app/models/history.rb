# == Schema Information
#
# Table name: histories
#
#  id          :integer          not null, primary key
#  table_id    :integer
#  user_id     :integer
#  for_type    :string           default("sale")
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class History < ActiveRecord::Base
  has_many    :options_for_history
  belongs_to  :table
  belongs_to  :user

  def self.create_history_for_new_object(object)
    history = History.new(table_id: object.id,
                          user_id:  object.user_id,
                          for_type: object.type)
    history.save
  end

  def self.create_history_for_update_object(object, params)
    history = History.new(table_id:    object.id,
                          user_id:     object.user_id,
                          for_type:    object.type,
                          description: params.values.first)
    history.save
    option = OptionsForHistory.new(history_id:          history.id,
                                   history_option_type: params.keys.first.gsub("_id", "").capitalize,
                                   history_option_id:   params.values.first.to_i)
    option.save
  end

  def self.history_for_entity(type, order)
    where(for_type: type.capitalize).order(created_at: order)
  end
end
