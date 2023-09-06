Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users
  root :to =>"homes#top"
  get "home/about"=>"homes#about"

 resources :books, only: [:index, :show, :edit, :create, :destroy, :update] do
   resources :book_comments, only: [:create, :destroy]
   resource :favorites, only: [:create, :destroy]
 end

  resources :users, only: [:index, :show, :edit, :update] do
    member do#resourcesで生成されるルートに、決められたルート以外のルートを追加するための処理!
             #resourcesのブロック（doとend）の中で使います。
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

 resources :users, only: [:show,:edit,:update]
 resources :messages, only: [:create]
 resources :rooms, only: [:create,:show]

 get "search" => "searches#search"
 #カテゴリー検索用のルート
 get 'tagsearches/search', to: 'tagsearches#search'
 #グループ作成
 resources :groups, only:  [:new, :index, :show, :create, :edit, :update] do
    resource :group_users, only: [:create, :destroy]
  end
end
