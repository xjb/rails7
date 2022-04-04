RSpec.configure do |config|
  config.order = :random
  config.example_status_persistence_file_path = "spec/examples.txt"

  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActiveJob::TestHelper, type: :job
  config.include ActiveJob::TestHelper, type: :mailer
end
