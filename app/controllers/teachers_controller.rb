class TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

  helper_method :teachers_cache_key

  # GET /teachers
  def index
    @teachers = Teacher.order(:id).page(params[:page])
    fresh_when etag: teachers_cache_key
  end

  # GET /teachers/1
  def show
    fresh_when last_modified: @teacher.updated_at
    expires_in 1.minute
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
    fresh_when [ @teacher, form_authenticity_token ]
  end

  # GET /teachers/1/edit
  def edit
    fresh_when [ @teacher, form_authenticity_token ]
  end

  # POST /teachers
  def create
    @teacher = Teacher.new(teacher_params)

    if @teacher.save
      redirect_to @teacher, notice: 'Teacher was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /teachers/1
  def update
    if @teacher.update(teacher_params)
      redirect_to @teacher, notice: 'Teacher was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /teachers/1
  def destroy
    @teacher.destroy
    redirect_to teachers_path, notice: 'Teacher was successfully destroyed.'
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_teacher
    @teacher = Teacher.find(params[:id])
    @title = @teacher.name
  end

  # Only allow the white list through.
  def teacher_params
    params.require(:teacher).permit(:name)
  end

  def teachers_cache_key
    "teachers/page-#{params[:page] || 1}-#{teachers_count}-#{teachers_max_updated_at}"
  end

  def teachers_count
    Rails.cache.fetch('teachers-count') { Teacher.count }
  end

  def teachers_max_updated_at
    Rails.cache.fetch('teachers-max-updated-at') do
      Teacher.maximum(:updated_at).try(:utc).try(:to_s, :number)
    end
  end
end
