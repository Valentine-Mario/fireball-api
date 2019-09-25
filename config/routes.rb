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
    get '/get/:token', :to=>'user#getUserByToken'
  end


  scope 'login' do
    post '/user', :to=>'auth#login'
    post '/admin', :to=>'auth#adminLogin'
  end

  scope 'admin' do
    get '/makeadmin/:id', :to=>'admin#makeAdmin'
    get '/removeadmin/:id', :to=>'admin#removeAdmin'
    get '/getusers', :to=>'admin#getAllUsers'
  end
end
