if Rails.env.development?
  ActiveSupport::Reloader.to_prepare do
    ApplicationController.after_action :console
  end
end
