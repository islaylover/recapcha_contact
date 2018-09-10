class ApplicationMailer < ActionMailer::Base
  default from: 'from@abc.com'
  layout 'mailer'
end
