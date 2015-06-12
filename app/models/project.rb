class Project < ActiveRecord::Base
  enum status: [ :active, :close ]
  enum kind: [ :commercial, :problem, :internal, :org ]

  scope :summary_job, -> { Project.all.order(:kind) - Project.org }

  validates :name, presence: true

  has_and_belongs_to_many :users, dependent: :destroy
  has_many :reports, dependent: :destroy

  def self.all_active
    where(status: "active")
  end

  def self.all_exsept_project_current_user user
    all_active.map{|project| [project.name, project.id, project.kind]}.select do |project|
      project unless Project.find(project[1]).users.include? user
    end
  end

  def self.all_project_current_user user
    all_active.map{|project| [project.name, project.id, project.kind]}.select do |project|
      project if Project.find(project[1]).users.include? user
    end
  end
end
