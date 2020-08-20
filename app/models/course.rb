class Course < ApplicationRecord
  validates :title, :short_description, :language, :price, :level, presence: true
  validates :description, presence: true, length: { minimum: 5 }

  validates :title, uniqueness: true

  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments
  has_rich_text :description

  scope :latest, -> { order(created_at: :desc).limit(3)}
  scope :top_rated, -> { order(avarage_rating: :desc, created_at: :desc).limit(3) }
  scope :popular, -> { order(enrollments_count: :desc, created_at: :desc).limit(3) }

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
    self.enrollments.where(user_id: [user.id], course_id: [self.id].empty?)
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :avarage_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :avarage_rating, (0)
    end
  end

end
