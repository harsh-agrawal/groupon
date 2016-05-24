class ApplicationMailer < ActionMailer::Base
  #FIXME_AB: Do as discussed. config/constants.ymlo
  default from: "from@example.com"
  layout 'mailer'
end
