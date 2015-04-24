class SimpleText < ActiveRecord::Base

  def self.find_or_create(name)
    where(name: name).first_or_initialize
  end

  def self.text_for_candidate
  	where(name: "interview_text").first.text
  end
end
