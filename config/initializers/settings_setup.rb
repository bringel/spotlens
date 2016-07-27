if ActiveRecord::Base.connection.table_exists?('application_settings')
  appSettings = ApplicationSetting.first

  if appSettings == nil
    appSettings = ApplicationSetting.create({ :photo_fetch_timer => 60, :photo_switch_timer => 30, :hashtags => '[]' })
  end

  ENV['photo_fetch_timer'] = appSettings.photo_fetch_timer.to_s || '60'
  ENV['photo_switch_timer'] = appSettings.photo_switch_timer.to_s || '30'
  ENV['hashtags'] = appSettings.hashtags || '[]'
end
