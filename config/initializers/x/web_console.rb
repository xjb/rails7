if Rails.env.development?
  ActiveSupport::Reloader.to_prepare do
    ApplicationController.class_eval do
      after_action :enable_web_console

      private

      def enable_web_console
        console
      end
    end
  end
end
