Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '9UHmd8nj9k1jITawJqPhw', 'Lb1PiTSRYguxe13aoIx5Oj5VTOzHRVF2eLEGo3d7q0'
  Twitter.configure do |config|
    config.consumer_key = '9UHmd8nj9k1jITawJqPhw'
    config.consumer_secret = 'Lb1PiTSRYguxe13aoIx5Oj5VTOzHRVF2eLEGo3d7q0'
    config.oauth_token = 	'286524550-oDKnr1VbHnj2cX1uW9nm2wEQlN4MpaBXWQZ0nqpA'
    config.oauth_token_secret = 'vUCBZpCBRFcdAuHPJQDWO2RvOLBkcftvvrS1qamdQM'
  end
end