class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  validates :title, :content, :course, presence: true
  has_many :user_lessons, dependent: :destroy
  validates :title, length: { maximum: 70 }
  validates_uniqueness_of :title, scope: :course_id

  has_rich_text :content

  has_one_attached :video
  has_one_attached :video_thumbnail
  validates :video,
    content_type: ['video/mp4'], 
    size: { less_than: 50.megabytes , message: 'size should be under 50 megabytes' }
  validates :video_thumbnail,
    content_type: ['image/png', 'image/jpg', 'image/jpeg'], 
    size: { less_than: 500.kilobytes , message: 'size should be under 500 kilobytes' }

  extend FriendlyId
  friendly_id :title, use: :slugged

  include RankedModel
  ranks :row_order, :with_same => :course_id

  include PublicActivity::Model
  tracked owner: Proc.new { |controller, model| controller.current_user }

  def to_s
    title
  end

  def viewed(user)
    self.user_lessons.where(user: user).present?
    #self.user_lesson.where(user_id: [user.id], lesson_id: [lesson.id]).empty?
  end

  def prev
    course.lessons.where("row_order < ?", row_order).order(:row_order).last
  end

  def next
    course.lessons.where("row_order > ?", row_order).order(:row_order).first
  end

end
