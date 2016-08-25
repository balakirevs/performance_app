class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize
  before_action :toggle_turbolinks

  helper_method :current_user, :current_user_courses, :students_cache_key,
                :courses_cache_key

  etag { flash }
  etag { current_user.try(:id) }
  etag { current_user.try(:name) }
  etag { session[:turbolinks] }

private

  def authorize
    Rack::MiniProfiler.authorize_request
  end

  # Disable turbolinks until enabled:
  #   ?turbolinks=off
  # Re-enable it:
  #   ?turbolinks=on
  def toggle_turbolinks
    session[:turbolinks] = params[:turbolinks] || session[:turbolinks] || 'on'
  end

  def current_user
    Student.find_by_id(session[:current_user_id]) if session[:current_user_id]
  end

  def current_user_courses
    current_user.courses.select(:id, :name, :teacher_id, :enrollments_count, :updated_at).
                         order(:name).includes(:teacher)
  end

  def students_cache_key
    "students/page-#{params[:page] || 1}-#{students_count}-#{students_max_updated_at}"
  end

  def students_count
    Rails.cache.fetch('students-count') { Student.count }
  end

  def students_max_updated_at
    Rails.cache.fetch('students-max-updated-at') do
      Student.maximum(:updated_at).try(:utc).try(:to_s, :number)
    end
  end

  def courses_cache_key
    "courses/page-#{params[:page] || 1}-#{courses_count}-#{courses_max_updated_at}-" +
       "teachers/#{teachers_count}-#{teachers_max_updated_at}"
  end

  def courses_count
    Rails.cache.fetch('courses-count') { Course.count }
  end

  def courses_max_updated_at
    Rails.cache.fetch('courses-max-updated-at') do
      Course.maximum(:updated_at).try(:utc).try(:to_s, :number)
    end
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
