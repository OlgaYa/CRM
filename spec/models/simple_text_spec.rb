# == Schema Information
#
# Table name: simple_texts
#
#  id         :integer          not null, primary key
#  name       :string
#  text       :text
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe SimpleText, type: :model do
end
