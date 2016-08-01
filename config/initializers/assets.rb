# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( admin/deals.js )
Rails.application.config.assets.precompile += %w( admin/admin.css )
Rails.application.config.assets.precompile += %w( admin/admin.js )
Rails.application.config.assets.precompile += %w( admin/form.css )
Rails.application.config.assets.precompile += %w( admin/location.css )
Rails.application.config.assets.precompile += %w( cycle.js )
Rails.application.config.assets.precompile += %w( slideshow.js )
Rails.application.config.assets.precompile += %w( merchant/merchant.css )
Rails.application.config.assets.precompile += %w( merchant/merchant.js )
Rails.application.config.assets.precompile += %w( polling.js )


Rails.application.configure do
  config.assets.precompile += %w[
    serviceworker.js
  ]
end
