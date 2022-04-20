require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch

  # minimum_coverage line: 90, branch: 80
  # minimum_coverage_by_file line: 90, branch: 80

  # add_filter do |source_file|
  #   source_file.lines.count < 5
  # end

  add_filter "app/channels"
  # add_filter "app/jobs"

  add_group "Decorators", "app/decorators"
  add_group "Services", "app/services"
  groups.delete("Channels")
  groups.delete("Jobs")
  groups.delete("Libraries")
end
