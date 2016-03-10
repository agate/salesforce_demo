require 'mysql2'
require 'yaml'
client = Mysql2::Client.new(host: 'localhost', username: 'root', password: 'root', database: 'factual')
res = client.query('SELECT * FROM user_action_tasks')
fixtures = res.map do |x|
  %w{id processed mailchimp_processed
     salesforce_processed updated_at}.each do |k|
    x.delete(k)
  end

  %w{opt_in email_confirmed technical_opt_in
     uses_geo_loc is_mobile sells_ads}.each do |k|
    x[k] = x[k] == 1
  end

  x
end.to_yaml

File.write(File.expand_path('../../fixtures/user_actions.yml', __FILE__), fixtures)
