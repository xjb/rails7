Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.google[:client_id],
           Rails.application.credentials.google[:client_secret]

  provider :github,
           Rails.application.credentials.github[:client_id],
           Rails.application.credentials.github[:client_secret]

  provider :microsoft_office365,
           Rails.application.credentials.microsoft[:client_id],
           Rails.application.credentials.microsoft[:client_secret]

  provider :microsoft_graph,
           Rails.application.credentials.microsoft[:client_id],
           Rails.application.credentials.microsoft[:client_secret],
           #  scope: "openid email profile User.Read"
           scope: "openid"

  provider :gitlab,
           Rails.application.credentials.gitlab[:client_id],
           Rails.application.credentials.gitlab[:client_secret],
           scope: "openid read_user"
end
