# README

GCE上でRuby on Rails 5.2で「Action Mailer」と「GoogleのreCAPTCHA」を使ってお問い合わせメールを作る


Things you may want to cover:

* Ruby version　5.2

* System dependencies
 -Gemfiles-
 gem "recaptcha", require: "recaptcha/rails"

* Configuration



##  前準備
```
前準備1:メール送信関連

Google Compute Engineではメール送信はそのままではできない。


引用開始
Google Compute Engine では、ポート 25 での送信接続は許可されません。これの送信 SMTP ポートは、不正使用に利用されることが多いため、デフォルトでブロックされています。また、SendGrid、Mailgun、Mailjet などの信頼できるサードパーティ プロバイダを利用すると、Compute Engine で IP 評価と受信者を管理する必要がなくなります。
引用終了
```
参照　：　https://cloud.google.com/compute/docs/tutorials/sending-mail/?hl=ja
※「SendGrid に登録し、postfixの設定を変えて今回は対応した。

手順参考サイト：　https://www.apps-gcp.com/sendgrid-gce/#3sendmail
```
GCEの自分のサーバ上で下記コマンドで実際にメールが飛ぶか確認 ※メールアドレスは自分の環境に合わせる
[root@xxx-N-vm:/home/oreore]#printf 'Subject: test\r\n\r\npassed' | sendmail hello@abc.com
```

## 前準備2 GoogleのreCAPTCHAのアカウント登録・キーの登録
GoogleのreCAPTCHA[https://www.google.com/recaptcha/intro/v3beta.html]のアカウント、登録し、サイトキーとセキュリティーキーを取得しておく

手順参考サイト：
http://tango-ruby.hatenablog.com/entry/2016/01/21/191706
https://qiita.com/amagasu1234/items/9760c2c410776fd02e12

## 1 credentials.yml.encにreCAPCHAのキーの登録
```
1:applicationのパスに移動
[root@xxx-N-vm:/home/oreore]#cd /var/www/contactmail 
2:reCAPCHAのキーの登録
[root@xxx-N-vm:/var/www/contactmail]#EDITOR=vim bin/rails credentials:edit
RECAPTCHA_SECRET_KEY: hogehoge1234567890ABCDEFG    *各自のキーにあわせる
RECAPTCHA_SITE_KEY: ho1234gehoge1234567890ABCDEFG  *各自のキーにあわせる
3:設定内容の確認
[root@xxx-N-vm:/var/www/contactmail]#rails c
Loading development environment (Rails 5.2.0)
irb(main):001:0> Rails.application.credentials.RECAPTCHA_SECRET_KEY
>> "hogehoge1234567890ABCDEFG"
と表示されればOK
参考サイト：
https://qiita.com/NaokiIshimura/items/2a179f2ab910992c4d39
```

## 2 ambethia/recaptcha のGemを入れる
```
[root@xxx-N-vm:/var/www/contactmail]#vi Gemfile
gem "recaptcha", require: "recaptcha/rails" <-- 追記
[root@xxx-N-vm:/var/www/contactmail]#bundle install
```

## 3 イニシャルファイルにreCAPCHAのキーの設定を記述
```
[root@xxx-N-vm:/var/www/contactmail]#vi config/initializers/recaptcha.rb

Recaptcha.configure do |config|
  config.site_key=Rails.application.credentials.RECAPTCHA_SITE_KEY      #さきほどのcredentialsをここでよぶ
  config.secret_key=Rails.application.credentials.RECAPTCHA_SECRET_KEY  #さきほどのcredentialsをここでよぶ
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end

```
参考サイト：
http://tango-ruby.hatenablog.com/entry/2016/01/21/191706


## 4 action mailer
自動生成コマンド実行
```
[root@xxx-N-vm:/var/www/contactmail]#bin/rails generate mailer GuestMailer
app/mailers/application_mailer.rb
app/mailers/guest_mailer.rb
app/views/guest_mailer
app/views/layouts/mailer.text.erb
app/views/layouts/mailer.html.erb
```
メイラービューを作成する
```
[root@xxx-N-vm:/var/www/contactmail]#touch app/views/guest_mailer/inquiry_email.text.erb
[root@xxx-N-vm:/var/www/contactmail]#touch app/views/guest_mailer/inquiry_email.html.erb
```
参考サイト：
https://railsguides.jp/action_mailer_basics.html

問い合わせページ生成
```
[root@xxx-N-vm:/var/www/contactmail]#touch app/controller:app/controllers/question_controller.rb
[root@xxx-N-vm:/var/www/contactmail]#touch app/models/form/inquiry.rb  <-- 問い合わせ内容のvalidation
[root@xxx-N-vm:/var/www/contactmail]#touch app/views:contact/inquiry.html.erb <-- 問い合わせページ
[root@xxx-N-vm:/var/www/contactmail]#touch app/views:contact/confirm.html.erb <-- 確認ページ
[root@xxx-N-vm:/var/www/contactmail]#touch app/views:contact/finish.html.erb  <-- 完了ページ
```

localesファイル準備
```
[root@xxx-N-vm:/var/www/contactmail]#touch config/locales/ja.yml
[root@xxx-N-vm:/var/www/contactmail]#touch config/locales/en.yml
```
