class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :approve, :unapprove, :analitics]
  before_action :perform_authorization, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: [:show]

  def index
    @ransack_path = courses_path
    @ransack_courses = Course.published.approved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))

  end

  def show
    @lessons = @course.lessons.rank(:row_order)
    @enrollments_with_review = @course.enrollments.reviewed
  end

  def new
    @course = Course.new
  end

  def purchased
    @ransack_path = purchased_courses_path
    @ransack_courses = Course.joins(:enrollments).where(enrollments: { user: current_user }).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  def pending_review
    @ransack_path = pending_review_courses_path
    @ransack_courses = Course.joins(:enrollments).merge(Enrollment.pending_review.where( user: current_user )).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  def created_courses
    @ransack_path = created_courses_courses_path
    @ransack_courses = Course.where(user: current_user).ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  def unapproved
    @ransack_path = unapproved_courses_path
    @ransack_courses = Course.unapproved.ransack(params[:courses_search], search_key: :courses_search)
    @pagy, @courses = pagy(@ransack_courses.result.includes(:user))
    render 'index'
  end

  def approve
    authorize @course, :approve?
    @course.update_attributes(approved: true)
    redirect_to @course, notice: 'Course has been approved and live now!'
  end

  def unapprove
    authorize @course, :approve?
    @course.update_attributes(approved: false)
    redirect_to @course, notice: 'Course has been unaproved and now hidden!'
  end

  def analitics
    authorize @course, :owner?
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user
    authorize @course

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url, notice: 'Course was successfully deleted.' }
        format.json { head :no_content }
      end
    else
      redirect_to @course, alert: 'Course has enrollments and cannot be deleted.'
    end
  end

  private
    def set_course
      @course = Course.friendly.find_by_slug!(params[:id])
    end

    def course_params
      params.require(:course).permit(:title, :description, :short_description, :price, :language, :level, :published, :avatar)
    end

    def perform_authorization
      authorize @course
    end
end
