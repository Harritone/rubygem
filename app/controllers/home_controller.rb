class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    @courses = Course.all.limit(3)
    @latest= Course.published.latest
    @good_reviews = Enrollment.reviewed.latest_good_reviews
    @top_rated= Course.published.top_rated
    @popular= Course.published.popular
    @purchased= Course.joins(:enrollments).where(enrollments: { user: current_user }).order(created_at: :desc).limit(3)
  end

  def activity
    if current_user.has_role?(:admin)
      @activities = PublicActivity::Activity.all
    else
      redirect_to root_path, alert: 'You are not authorized to see this page'
    end
  end

  def analitics
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: 'You are not authorized to see this page'
    end
  end
end
