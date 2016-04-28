require('pg')

dbconnection = PG.connect(ENV['DATABASE_URL'])

dbconnection.exec('CREATE TABLE IF NOT EXISTS settings(key text NOT NULL PRIMARY KEY, value text);')
result = dbconnection.exec('SELECT * FROM settings;')
result.each do |row|
  ENV[row['key']] = row['value']
end

ENV['photo_fetch_timer'] ||= '60'
ENV['photo_switch_timer'] ||= '30'
ENV['hashtags'] ||= '[]'
