class Admin::EmailTextsController < ApplicationController
  #defend_this controller: 'admin_email_texts'
  {
    "interview_text" => "Текст письма при приглашении на интервью"
  }.each do |action_name, title|
    define_method action_name do 
      signup = (toto = SimpleText.find_by_name(action_name)) ? toto : SimpleText.new(name: action_name)
      unless params[action_name.to_sym].blank?
        signup.text = params[action_name.to_sym]  
        signup.save
        flash[action_name.to_sym] = 'Текст письма обновленн'      
      end          
      @email_text = signup.text
      @title = title
      render action: "email_form"
    end
  end
end