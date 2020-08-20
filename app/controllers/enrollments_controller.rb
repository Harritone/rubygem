class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: [:show, :edit, :update, :destroy]
	before_action :set_course, only: [:new, :create]
  before_action :perform_authorization, only: [:edit, :update, :destroy]

  def index
    @ransack_path = enrollments_path
    @q = Enrollment.ransack(params[:q])
    @pagy, @enrollments = pagy(@q.result.includes(:user))
    authorize @enrollments
  end

  def show
  end

  def new
    @enrollment = Enrollment.new
  end

  def edit
  end

  def my_students
    @ransack_path = my_students_enrollments_path
    @q = Enrollment.joins(:course).where(courses: { user: current_user }).ransack(params[:q])

    @pagy, @enrollments = pagy(@q.result.includes(:user))
    render 'index'
  end

  def create
		if @course.price > 0
      flash[:alert] = "You can not access paid courses yet."
      redirect_to new_course_enrollment_path(@course)
    else
      @enrollment = current_user.buy_course(@course)
      redirect_to course_path(@course), notice: "You are enrolled!"
    end
  end

  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to @enrollment, notice: 'Enrollment was successfully updated.' }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: 'Enrollment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_enrollment
      @enrollment = Enrollment.friendly.find_by_slug!(params[:id])
    end

    def enrollment_params
      params.require(:enrollment).permit(:rating, :review)
    end

    def set_course
      @course = Course.friendly.find_by_slug!(params[:course_id])
    end

    def perform_authorization
      authorize @enrollment
    end
end

