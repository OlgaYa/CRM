class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name

      t.timestamps null: false
    end
    add_column :tasks, :status_id, :integer
  end

  # def save_status
  #   status_names = Task.all.pluck(:status)
  #   status_names.each{|name| Status.new(name: name).save }
    # Task.all.each do |task|
    #   status_id = Status.find_by(name: task.status).id
    #   task.update_attribute(:status_id, status_id)
    # end
  # end
end
