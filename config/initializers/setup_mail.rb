ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name            => "crm.sloboda.studio@gmail.com",
    :password             => "Sloboda123",
    :authentication       => "plain",
    #:enable_starttls_auto => true
}

#config.action_mailer.delivery_method = :smtp
#config.action_mailer.perform_deliveries = true
#config.action_mailer.default_charset = "utf-8"
#config.action_mailer.raise_delivery_errors = true