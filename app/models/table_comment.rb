class TableComment < ActiveRecord::Base
  belongs_to :comment
  belongs_to :table
end
