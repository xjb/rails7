Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :google_oauth2,
            Rails.application.credentials.google[:client_id],
            Rails.application.credentials.google[:client_secret]
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :github,
            Rails.application.credentials.github[:client_id],
            Rails.application.credentials.github[:client_secret]
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :microsoft_office365,
            Rails.application.credentials.microsoft[:client_id],
            Rails.application.credentials.microsoft[:client_secret]
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :microsoft_graph,
            Rails.application.credentials.microsoft[:client_id],
            Rails.application.credentials.microsoft[:client_secret],
            # scope: "openid email profile User.Read"
            scope: "openid"
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :gitlab,
            Rails.application.credentials.gitlab[:client_id],
            Rails.application.credentials.gitlab[:client_secret],
            scope: "openid read_user"
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :keycloak_openid,
            Rails.application.credentials.keycloak[:client_id],
            Rails.application.credentials.keycloak[:client_secret],
            client_options: {
              site: ENV.fetch("KEYCLOAK_URL", ""),
              realm: "master",
              base_url: ""
            },
            name: "keycloak"
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider  :twitter2,
            Rails.application.credentials.twitter[:client_id],
            Rails.application.credentials.twitter[:client_secret],
            # callback_path: "/auth/twitter2/callback",
            scope: "tweet.read users.read"
end
