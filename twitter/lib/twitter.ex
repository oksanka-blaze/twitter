defmodule Twitter do
  @moduledoc """
  Documentation for `Twitter`.
  """

  def post_media do
    ExTwitter.configure(
      consumer_key: "YOUR KEY",
      consumer_secret: "YOUR SECRET",
      access_token: "YOUR TOKEN",
      access_token_secret: "YOUR TOKEN SECRET"
    )

    media_id = ExTwitter.upload_media("/tmp/thumbup.png", "image/png")
    IO.puts(media_id)
  end

  def post_tweet(text) do
    consumer_key = "YOUR KEY"
    consumer_secret = "YOUR KEY"
    access_token = "YOUR TOKEN"
    access_token_secret = "YOUR TOKEN SECRET"

    credentials = OAuther.credentials(
            consumer_key: consumer_key,
            consumer_secret: consumer_secret,
            token: access_token,
            token_secret: access_token_secret
        )

    create_tweet_url = "https://api.twitter.com/2/tweets"
    # create_tweet_url = "http://localhost:8080"
    # brew install netcat
    # netcat -l -p 8080
    method = "post"
    content_type = {"content-type", "application/json"}

    # For the request of type 'application/json' the body of the
    # request should not be signed, thus the [] param.
    signed_params = OAuther.sign(method, create_tweet_url, [], credentials)

    {authorization_header, _req_params} = OAuther.header(signed_params)
    headers = [content_type, authorization_header]

    params = %{
      text: text,
      media: %{media_ids: ["1543698114384740356"]},
      poll: %{options: ["yes", "maybe", "no"], duration_minutes: 120}
    }

    body = Jason.encode!(params)

    HTTPoison.post(create_tweet_url, body, headers)
  end
end
