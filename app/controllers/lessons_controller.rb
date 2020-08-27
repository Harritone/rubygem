class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy, :delete_video]
  before_action :set_course, only: [:create, :show, :edit, :update, :destroy, :delete_video]
  before_action :perform_authorization, only: [:update, :edit, :destroy, :show]

  def delete_video
    authorize @lesson, :edit?
    @lesson.video.purge
    @lesson.video_thumbnail.purge
    redirect_to edit_course_lesson_path(@course, @lesson), notice: 'Video successfully deleted!'
  end

  def sort
    @course = Course.friendly.find_by_slug(params[:course_id])
    lesson = Lesson.friendly.find_by_slug(params[:lesson_id])
    authorize lesson, :edit?
    lesson.update(lesson_params)
    render body: nil
  end

  def index
    @lessons = Lesson.all
  end

  def show
    current_user.view_lesson(@lesson)
    @lessons = @course.lessons.rank(:row_order)
  end

  def new
    @lesson = Lesson.new
    @course = Course.friendly.find_by_slug!(params[:course_id])
  end

  def edit
  end

  def create
    @lesson = Lesson.new(lesson_params)
    @course = Course.friendly.find_by_slug!(params[:course_id])
    @lesson.course_id = @course.id
    authorize @lesson

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to course_lesson_path(@course, @lesson), notice: 'Lesson was successfully created.' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to course_lesson_path(@course, @lesson), notice: 'Lesson was successfully updated.' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to course_path(@lesson.course), notice: 'Lesson was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_lesson
    @lesson = Lesson.friendly.find_by_slug!(params[:id])
  end

  def set_course
    @course = Course.friendly.find_by_slug!(params[:course_id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :content, :course_id, :row_order_position, :video, :video_thumbnail)
  end

  def perform_authorization
    authorize @lesson
  end
end
