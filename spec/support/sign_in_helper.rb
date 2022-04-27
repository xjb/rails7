module RSpecHelpers
  module SignInHelper
    def sign_in(user = nil)
      user ||= OmniAuth::AuthHash.new(uid: 0)
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(Authenticable).to receive(:current_user).and_return(user)
      # rubocop:enable RSpec/AnyInstance
    end
  end
end

RSpec.configure do |config|
  config.include RSpecHelpers::SignInHelper, type: :request
end

# NOTE: `it_behaves_like "unauthenticated"`
RSpec.shared_examples "unauthenticated" do
  subject { response }

  it { is_expected.to redirect_to root_path }
end
