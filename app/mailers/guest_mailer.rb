class GuestMailer < ApplicationMailer
  default from: 'notifications@abc.com' #自分のサイトに合わせる

  def inquiry_email(user)
    @user = user
    to_mail = 'cs_service@abc.com' #自分のサイトに合わせる
    mail(to: to_mail, subject: 'Welcome to ABC.com')
  end
end
