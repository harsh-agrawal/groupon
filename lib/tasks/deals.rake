namespace :deals do
  desc "check expired deals, validates them, generate coupon or refund"
  task process: :environment do
    Deal.for_coupon_processing.includes(orders: [:user]).each do |deal|
      deal.transaction do
        Rails.logger.info "Processing Deal##{deal.id} - #{deal.title}"
        deal.orders.each do |order|
          Rails.logger.info "Generating #{order.quantity} coupons for Order##{order.id}"
          order.quantity.times do
            coupon = order.coupons.build
          end
          order.status = 'processed'
          order.processed_at = Time.current
          debugger
          order.save!
        end
        deal.processed = true
        deal.save!
      end
    end

    Deal.for_refund_processing.includes(orders: [:user]).each do |deal|
      deal.transaction do
        Rails.logger.info "Processing Deal##{deal.id} - #{deal.title}"
        deal.orders.each do |order|
          Rails.logger.info "Refunding for Order##{order.id}"
          order.status = 'refunded'
          order.processed_at = Time.current
          order.save!
        end
        deal.processed = true
        deal.save!
      end
    end
  end
end
