class ContactController < ApplicationController

  force_ssl
  layout 'application'

  #問い合わせページ
  def inquiry

    @inquiry = Form::Inquiry.new
    @inquiry.name = params[:name]
    @inquiry.email = params[:email]
    @inquiry.message = params[:message]

   end

  #問い合わせ確認ページ
  def confirm

    @inquiry = Form::Inquiry.new
    @inquiry.name = params[:name]
    @inquiry.email = params[:email]
    @inquiry.message = params[:message]

    #入力チェックOK --> 確認ページのビューを表示
    if @inquiry.valid? && verify_recaptcha(model: @inquiry)
      render :action => 'confirm'
    # 入力チェックNG --> 入力ページのビューを表示
    else
      render :action => 'inquiry'
    end
  end

  def finish

    #お問い合わせメール送信
    @inquiry = Form::Inquiry.new
    @inquiry.name = params[:name]
    @inquiry.email = params[:email]
    @inquiry.message = params[:message]
    GuestMailer.inquiry_email(@inquiry).deliver_now

  end


end
