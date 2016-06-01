if @published
  json.status 'success'
else
  json.status 'failure'
  json.deal_title @deal.title
  json.errors @errors_full_messages
end
