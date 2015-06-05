class ChangeColumnsProject < ActiveRecord::Migration
  def up
  	Project.connection.execute("update projects set status='0'")
  	Project.connection.execute("update projects set kind='0'")
  	change_column :projects, :status, 'integer USING CAST(status AS integer)', default: 0
  	change_column :projects, :kind, 'integer USING CAST(kind AS integer)', default: 0
  end

  def down
  	change_column :projects, :status, :string
  	change_column :projects, :kind, :string
  end

end
