class Course < ApplicationRecord
  validates :title, :short_description, :language, :price, :level, presence: true
  validates :description, presence: true, length: { minimum: 5, maximum: 3000 }
  validates :short_description, presence: true, length: { maximum: 3000 }

  validates :title, uniqueness: true, length: { maximum: 70 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }


  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons
  
  has_one_attached :avatar

  validates :avatar, presence: true,
    content_type: ['image/png', 'image/jpg', 'image/jpeg'],
    size: { less_than: 500.kilobytes , message: 'size should be under 500 kilobytes' }

  #validates :avatar, attached: true, 
  #  content_type: ['image/png', 'image/jpg', 'image/jpeg'],
  #  size: { less_than: 500.kilobytes , message: 'size should be under 500 kilobytes' }


  has_rich_text :description

  scope :latest, -> { order(created_at: :desc).limit(3)}
  scope :top_rated, -> { order(avarage_rating: :desc, created_at: :desc).limit(3) }
  scope :popular, -> { order(enrollments_count: :desc, created_at: :desc).limit(3) }
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

  extend FriendlyId
  friendly_id :title, use: :slugged

  LEVELS = [:"Begginer", :"Intermediate", :"Advanced"]

  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  LANGUAGES = [:"English", :"Russian", :"Spanish", :"Polish", :"French"]

  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  def to_s
    title
  end

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).any?
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :avarage_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :avarage_rating, (0)
    end
  end

  def progress(user)
    unless self.lessons_count == 0
    (user_lessons.where(user: user).count/self.lessons_count.to_f) * 100
    end
  end


end
