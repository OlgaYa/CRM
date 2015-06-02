# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  alt        :string
#  href       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  table_id   :integer
#

require 'rails_helper'

RSpec.describe Link, type: :model do
end
