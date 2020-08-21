Rails.application.routes.draw do
  devise_for :users

  root 'home#index'

  resources :enrollments do
    get :my_students, on: :collection
  end

  resources :courses do
    get :created_courses, :purchased, :pending_review, on: :collection
    resources :lessons
    resources :enrollments, only: [:new, :create]
  end

  resources :users, only: [:index, :edit, :show, :update]
  get 'home/index'
  get 'activity', to: 'home#activity'
  get 'analitics', to: 'home#analitics'

  namespace :charts do
    get 'money_makers'
    get 'users_per_day'
    get 'enrollments_per_day'
    get 'course_popularity'
  end
end
