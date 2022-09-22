InertiaRails.configure do |config|
  config.default_render = true
  config.version = lambda do 
    ENV['GIT_REV']
  end
end