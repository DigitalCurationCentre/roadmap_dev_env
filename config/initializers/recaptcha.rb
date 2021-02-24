Recaptcha.configure do |config|
  #config.site_key = Rails.application.credentials.recaptcha[:site_key]
  #config.secret_key = Rails.application.credentials.recaptcha[:secret_key]
  config.site_key  = '6LcO9RQUAAAAAAlSp5UVsuY7WJpXnZaKvs0jaLk_'
  config.secret_key = '6LcO9RQUAAAAANkv9aNE8QMiYz1AJoQe2Bnuz9KT'
  config.proxy = 'http://someproxy.com:port'
end
