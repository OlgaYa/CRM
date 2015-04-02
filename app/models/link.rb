class Link < ActiveRecord::Base
  belongs_to :task
  belongs_to :table
end
