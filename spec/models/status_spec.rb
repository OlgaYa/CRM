# == Schema Information
#
# Table name: statuses
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  for_type   :string           default("sale")
#

require 'rails_helper'

RSpec.describe Status, type: :model do
end
