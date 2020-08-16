class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable

  rolify

  has_many :courses

  def username
    if email.present?
      self.email.split(/@/).first
    end
  end

  ransacker :sign_in_count do
    Arel.sql("to_char(\"#{table_name}\".\"sign_in_count\", '99999999')")
  end

  def to_s
    email
  end

    after_create :assign_default_role

  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.role.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:student)
      self.add_role(:teacher)
    end
  end
end
