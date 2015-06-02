# == Schema Information
#
# Table name: table_comments
#
#  id         :integer          not null, primary key
#  table_id   :integer
#  comment_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe TableComment, type: :model do
end
