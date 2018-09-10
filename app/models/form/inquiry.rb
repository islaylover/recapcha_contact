# お問い合わせメールの入力内容をvalidation
class Form::Inquiry

  include ActiveModel::Model #DBと無関係なモデル

  attr_accessor :name, :email, :message
  validates :name, :presence => true
  validates :message, :presence => true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }
end
