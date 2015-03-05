require 'net/imap'
require 'net/http'

class Message < ActiveRecord::Base
	belongs_to :user


	def self.check_mailing
	  config = YAML.load(File.read(File.join(Rails.root, 'config', 'imap.yml')))
	  imap = Net::IMAP.new(config['host'],config['port'],true)
	  imap.login(config['username'], config['password'])
	  imap.select('INBOX')
	 
	  imap.search(["SUBJECT", "Task", "NOT", "SEEN"]).each do |mail|
	    message = Mail.new(imap.fetch(mail, "RFC822")[0].attr["RFC822"])
	   
	    plain_body = message.multipart? ? (message.text_part ? message.text_part.body.decoded : nil) : message.body.decoded
	   	date = message.date
	    from_email = message.from
	    task_id = message.subject.scan( /\d+$/ ).first
	    user_id = User.find_by(email: from_email).id
	    self.new(user_id: user_id, body: plain_body, datetime: date, task_id: task_id).save
	    imap.store(mail, "+FLAGS", [:Seen])
	  end
	  imap.logout()
	  imap.disconnect()
	end
end
