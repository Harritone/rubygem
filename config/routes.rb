Rails.application.routes.draw do
  resources :enrollments
  devise_for :users
  resources :courses do
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end

  resources :users, only: [:index, :edit, :show, :update]
  get 'home/index'
  get 'home/activity'
  root 'home#index'
end
