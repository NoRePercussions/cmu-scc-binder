Trailerapp::Application.routes.draw do

  resources :documents
  resources :faqs, :except => [:show]
  resources :organizations do
    resources :aliases, :controller => :organization_aliases, :shallow => true, :only => [:create, :new, :destroy]
    resources :statuses, :controller => :organization_statuses, :as => :organization_statuses
    resources :participants, :only => [:index]
    resources :shifts, :only => [:index]
    resources :tools, :only => [:index]
    resources :charges, :only => [:index]
    get 'hardhats', on: :member
  end
  resources :organization_timeline_entries, :controller => :organization_timeline_entries, :only => [:create, :update, :destroy] do
    put 'end', on: :member
  end
  resources :charges do
    put 'approve', on: :member
  end
  resources :participants do
    resources :memberships, :except => [:index, :show, :destroy]
    post 'lookup', on: :collection
  end
  resources :shifts do
    resources :participants, :controller => :shift_participants, :only => [:new, :create, :destroy]
  end
  resources :tasks
  resources :tools do
    resources :checkouts, :only => [:new, :create, :update, :index] do
      post 'choose_organization', on: :collection
    end
  end
  resources :checkouts, :only => [:create]

  # static pages
  get "milestones" => "home#milestones", :as => "milestones"

  match "search" => "home#search", :as => "search", via: [:get, :post]
  get "home" => "home#home", :as => "home"

  root :to => "home#index"

  # Custom one-offs
  get 'hardhats' => "home#hardhats", :as => "hardhats"
  get 'charge_overview' => "home#charge_overview", :as => "charge_overview"
  get 'structural' => "organization_timeline_entries#structural", :as => "structural"
  get 'electrical' => "organization_timeline_entries#electrical", :as => "electrical"
  get 'downtime' => "home#downtime", :as => "downtime"


  devise_for :users,
  :controllers => {
    :omniauth_callbacks => 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :users
  
  unless Rails.env.production?
    post 'dev_login' => "home#dev_login", :as => "dev_login"
  end
end

