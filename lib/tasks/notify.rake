namespace :notify do
  desc "TODO"
  task live_deals: :environment do
    Deal.live.find_each do |deal|
      if !deal.notified?
        message = {
          title: "Groupon : New Deal",
          body: "A new deal has gone live. Check it out.",
          icon: "assets/icon.jpg",
          url: Rails.application.routes.url_helpers.deal_path(id: deal.id)
        }
        Subscription.find_each do |record|
          webpush_params = { message: JSON.generate(message), endpoint: record.endpoint, p256dh: record.payload, auth: record.auth, url: "hello" }
          Webpush.payload_send webpush_params
        end
        # deal.update(notified: true)
      end
    end
  end
end
