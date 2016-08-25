module ApplicationHelper
  def turbolinks_flag
    "data-no-turbolink" unless session[:turbolinks] == 'on'
  end
end
