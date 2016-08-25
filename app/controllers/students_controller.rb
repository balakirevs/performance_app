class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :set_courses, only: [:show]

  # GET /students
  def index
    @students = Student.order(:id).page(params[:page])
    fresh_when etag: students_cache_key
  end

  # GET /students/1
  def show
    fresh_when @student
  end

  # GET /students/new
  def new
    @student = Student.new(name: Faker::Name.name, email: Faker::Internet.email)
    fresh_when [ @student, form_authenticity_token ]
  end

  # GET /students/1/edit
  def edit
    fresh_when [ @student, form_authenticity_token ]
  end

  # POST /students
  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to @student, notice: 'Student was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /students/1
  def update
    if @student.update(student_params)
      redirect_to @student, notice: 'Logged in.'
    else
      render action: 'edit'
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy
    redirect_to students_path, notice: 'Student was successfully destroyed.'
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
    @title = @student.name
  end

  def set_courses
    @courses = @student.courses.order(:name).includes(:teacher).page(params[:page])
  end

  # Only allow the white list through.
  def student_params
    params.require(:student).permit(:name, :email)
  end
end
