defmodule TransportWeb.Plugs.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :transport,
    module: TransportWeb.Auth.Guardian,
    error_handler: TransportWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, token_type: "Bearer"
  plug Guardian.Plug.LoadResource
end
