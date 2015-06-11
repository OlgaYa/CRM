class TableComment < ActiveRecord::Base
  belongs_to :comment
  belongs_to :table

  after_create :update_date_table_after_create
  after_destroy :update_date_table_after_destroy

  def update_date_table_after_create
    table = self.table
    table.date = self.created_at
    table.save!
  end

  def update_date_table_after_destroy
    table = self.table
    table.date = table.comments.empty? ?  table.created_at : table.comments.order(:created_at).last.created_at
    table.save!
  end

end
