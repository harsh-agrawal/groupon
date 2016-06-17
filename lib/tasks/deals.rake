namespace :deals do
  desc "check deals expired and validate them"
  task check_expired: :environment do
    deals = Deal.valid_deals
    Deal.transaction do
      deals.each do |deal|
        deal.orders.each do |order|
          order.quantity.times do
            coupon = order.coupons.build
          end
          order.status = 'processed'
          order.save!
        end
      deal.processed = true
      deal.save!
      end
    end
  end
end
