Rails.application.routes.draw do
  root to: "home#index"

  resources :courses
  resources :teachers
  resources :students
  resources :enrollments, only: :create

  get "login"  => "sessions#create"
  get "logout" => "sessions#destroy"
end
