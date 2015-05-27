class Users::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, only: [:new, :create]
  prepend_before_filter :allow_params_authentication!, only: :create
end
