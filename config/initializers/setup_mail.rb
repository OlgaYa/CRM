ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "localhost",
    :user_name            => "Nastya",
    :password             => "secret",
    :authentication       => "plain",
    :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
#config.action_mailer.delivery_method = :smtp
#config.action_mailer.perform_deliveries = true
#config.action_mailer.default_charset = "utf-8"
#config.action_mailer.raise_delivery_errors = true