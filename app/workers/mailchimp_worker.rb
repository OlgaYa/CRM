# TODO delete logging
class MailchimpWorker

  include Sidekiq::Worker
  sidekiq_options queue: "mailchimp"

  def perform(h)

    @filename = "sidekiq_mailchimp.log"
    unless File.exist?("log/#{@filename}")
      File.new("log/#{@filename}", "w+")
    end
    log = ''

    @lists_hash = {
      :potential_clients => 'Potential clients',
      :potential_ror => 'Potential Ror',
      :potential_switchers => 'Potential Switchers',
      :junes => 'Junes',
      :other => 'Other'
    }

    log << "Start #{Time.now.strftime("%H:%M:%S")}\n"
    log << "\tId = #{h['id']} | email = #{h['email']} | type = #{h['type']} | specialization = #{h['specialization_name']} | level = #{h['level_name']} | name = #{h['name']}\n"

    unless h['email'].empty?

      @list_name = @lists_hash[:other]

      if h['type'] == 'Sale'
        @list_name = @lists_hash[:potential_clients]
      elsif h['type'] == 'Candidate'
        @list_name = @lists_hash[:junes] if h['specialization_name'] == 'ror' && h['level_name'] == 'junior'
        @list_name = @lists_hash[:potential_ror] if h['specialization_name'] == 'ror' && h['level_name'] != 'junior'
        @list_name = @lists_hash[:potential_switchers] if h['specialization_name'] == 'switcher'
      end

      log << "\tList_name = #{@list_name}\n"

      mailchimp_api_key = YAML.load_file("#{Rails.root.to_s}/config/mailchimp.yml")['api_key']
      gb = Gibbon::API.new(mailchimp_api_key)
      lists = gb.lists.list({:start => 0, :limit=> 100})['data'].map{ |l| {:id => l['id'], :name => l['name']} }

      @lists = lists.map do |list|
        {
          :list_id => list[:id],
          :list_name => list[:name],
          :members => gb.lists.members({:id => list[:id]})['data'].map{ |member| member['email'] }
        }
      end

      @list_id = lists.map{ |l| l[:name] == @list_name ? l[:id] : nil }.compact.first

      @flag_adding = true
      @lists.each do |list|
        emails =  list[:members]
        if emails.include?(h['email']) && list[:list_id] != @list_id
          gb.lists.unsubscribe(:id => list[:list_id], :email => {:email => h['email']}, :delete_member => true, :send_notify => false)
          log << "\tRemove member from list #{list[:list_name]}\n"
        end
        if emails.include?(h['email']) && list[:list_id] == @list_id
          @flag_adding = false
          log << "\tMember alredy subscribed list #{list[:list_name]}\n"
        end
      end

      begin
        if @flag_adding
          gb.lists.subscribe({:id => @list_id, :email => {:email => h['email']}, :merge_vars => {:FNAME => h['name'], :LNAME => ''}, :double_optin => false})
          log << "\tSuccess subscribe to list: #{@list_name}\n"
        end
        rescue => error
          log << "\tError: #{error.inspect}\n"
        end
    else
      log << "\tEmail is empty... exit\n"
    end

    log << "Finish #{Time.now.strftime("%H:%M:%S")}\n\n"
    File.open("log/#{@filename}", 'a') { |file| file.write("#{log}") }

  end

end
