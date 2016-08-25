class HomeController < ApplicationController
  def index
    @courses = Course.order(:id).page(params[:page]).
                      includes(:teacher).
                      select(:id, :name, :teacher_id, :updated_at, :enrollments_count)

    fresh_when etag: courses_cache_key
  end
end
