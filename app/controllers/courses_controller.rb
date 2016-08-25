class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :set_students, only: [:show]

  helper_method :enrolled?

  # GET /courses
  def index
    redirect_to root_path
  end

  # GET /courses/1
  def show
    if stale?([ @course, form_authenticity_token ])
      render template: "courses/tooltip", layout: false if params[:tooltip]
      # Otherwise render normal show view
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
    fresh_when [ @course, form_authenticity_token ]
  end

  # GET /courses/1/edit
  def edit
    fresh_when [ @course, form_authenticity_token ]
  end

  # POST /courses
  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /courses/1
  def update
    if @course.update(course_params)
      redirect_to @course, notice: 'Course was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /courses/1
  def destroy
    @course.destroy
    redirect_to courses_path, notice: 'Course was successfully destroyed.'
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.where(id: params[:id]).eager_load(:teacher).first!
    @title = @course.name
  end

  def set_students
    @students = @course.students.order(:id).page(params[:page])

    # Don't let kaminari call SELECT COUNT. Use the counter cache.
    @students = Kaminari.paginate_array(@students, total_count: @course.enrollments_count).
                         page(params[:page])
  end

  # Only allow the white list through.
  def course_params
    params.require(:course).permit(:name, :description, :teacher_id)
  end

  def enrolled?
    current_user && current_user.courses.find_by_id(@course.id)
  end
end
