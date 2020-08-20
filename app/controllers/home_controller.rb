class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @courses = Course.all.limit(3)
    @latest= Course.all.latest
    @good_reviews = Enrollment.reviewed.latest_good_reviews
    @top_rated= Course.top_rated
    @popular= Course.popular
    @purchased= Course.joins(:enrollments).where(enrollments: { user: current_user }).order(created_at: :desc).limit(3)
  end

  def activity
    @activities = PublicActivity::Activity.all
  end
end
