class SubscriptionsController < ApplicationController
  def create
    subscription_params = JSON.dump(params.fetch(:subscription, {}))
    subscription = JSON.parse(subscription_params)
    endpoint = subscription['endpoint']
    auth = subscription['keys']['auth']
    payload = subscription['keys']['p256dh']
    Subscription.find_or_create_by(endpoint: endpoint, payload: payload, auth: auth)
    head :ok
  end
end