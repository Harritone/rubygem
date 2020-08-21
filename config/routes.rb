Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end
  devise_for :users
  resources :courses do
    get :created_courses, :purchased, :pending_review, on: :collection
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end

  resources :users, only: [:index, :edit, :show, :update]
  get 'home/index'
  get 'activity', to: 'home#activity'
  get 'analitics', to: 'home#analitics'
  root 'home#index'
end
