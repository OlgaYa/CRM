class AddColumnMonthtoPlan < ActiveRecord::Migration
  def change
    remove_column :plans, :date_from
    remove_column :plans, :date_to
    
    add_column    :plans, :first_day_in_month, :date
  end
end
