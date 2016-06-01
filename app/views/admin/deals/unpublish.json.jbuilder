if @unpublished
  json.status 'success'
else
  json.status 'failure'
  json.deal_title @deal.title
  json.errors @deal.errors.full_messages
end
