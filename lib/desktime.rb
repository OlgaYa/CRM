class DeskTime

  HOST = 'https://desktime.com/api/2/json/'

  def initialize
    desktime_data = YAML.load_file("#{Rails.root.to_s}/config/desktime.yml")
    @password = desktime_data['password']
    @email = desktime_data['email']
    @app_key = desktime_data['app_key']
    @api_key = authorize['api_key']
  end

  def authorize
    response = RestClient.post(HOST, {:appkey => @app_key, :email => @email, :password => @password, :action => 'authorize' })
    JSON.parse response.body
  end

  def company
    response = RestClient.post(HOST, {:apikey => @api_key, :action => 'company'})
    JSON.parse response.body
  end

  def employees(date)
    response = RestClient.post(HOST, {:apikey => @api_key, :action => 'employees', :date=> date})
    JSON.parse response.body
  end

  def employee(id, date)
    response = RestClient.post(HOST, {:apikey => @api_key, :action => 'employee', :date=> date, :id => id})
    JSON.parse response.body
  end

  def users_time(desktime_employees)
    h = {}
    desktime_employees['employees'].each do |employee|
      h[employee.last['email']] = employee.last['d_working']
    end
    return h
  end

  def user_time(desktime_employees, user_email)
    return users_time(desktime_employees)[user_email]
  end

end


=begin

desktime = DeskTime.new

# получаем данные за какое-то число
desktime_employees = desktime.employees('2015-05-21')
user_email = 'zavyalov79@ukr.net'
user_time = desktime.user_time(desktime_employees, user_email) # время в секундах

=end

