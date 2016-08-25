class EnrollmentsController < ApplicationController
  def create
    @enrollment = Enrollment.new(enrollment_params)
    @enrollment.student_id = current_user.id

    if @enrollment.save
      redirect_to @enrollment.course, notice: "Congratulations. You are enrolled in #{@enrollment.course.name}."
    end
  end

private

  # Only allow the white list through.
  def enrollment_params
    params.require(:enrollment).permit(:course_id)
  end
end
