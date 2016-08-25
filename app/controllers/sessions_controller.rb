class SessionsController < ApplicationController
  rescue_from ActionController::RedirectBackError do
    redirect_to root_path
  end

  def create
    session[:current_user_id] = Student.offset(rand(Student.count)).first.try(:id)
    redirect_to :back, notice: "Logged in."
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to :back, notice: "Logged out."
  end
end
