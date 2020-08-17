class Course < ApplicationRecord
  validates :title, :short_description, :language, :price, :level, presence: true
  validates :description, presence: true, length: { minimum: 5 }

  belongs_to :user
  has_many :lessons, dependent: :destroy
  has_rich_text :description


  extend FriendlyId
  friendly_id :title, use: :slugged

  #friendly_id :generated_slug, use: :slugged
  LEVELS = [:"Begginer", :"Intermediate", :"Advanced"]

  def self.levels
    LEVELS.map { |level| [level, level] }
  end

  LANGUAGES = [:"English", :"Russian", :"Spanish", :"Polish", :"French"]

  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  def generated_slug
    require 'securerandom'
    @random_slag ||= persisted? ? friendly_id : SecureRandom.hex(4)
  end

  def to_s
    title
  end

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

end
