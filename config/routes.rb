Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope 'user' do
    post '/create', :to=>'user#createUser'
    get '/get', :to=>'user#getProfile'
    post '/addpics', :to=>'user#addPics'
    get '/removepics', :to=>'user#removePics'
    post '/editpasssword', :to=>'user#editPassword'
    get '/delete', :to=>'user#deleteUser'
    post '/edit', :to=>'user#editUser'
  end


  scope 'login' do
    post '/user', :to=>'auth#login'
    post '/admin', :to=>'auth#adminLogin'
  end
end
