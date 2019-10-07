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
    post '/forgotpassword', :to=>'user#forgotPassword'
    get '/podcast/history', :to=>'user#getPodcastHistory'
  end


  scope 'login' do
    post '/user', :to=>'auth#login'
    post '/admin', :to=>'auth#adminLogin'
  end

  scope 'admin' do
    get '/makeadmin/:id', :to=>'admin#makeAdmin'
    get '/removeadmin/:id', :to=>'admin#removeAdmin'
    get '/getusers', :to=>'admin#getAllUsers'
    get '/suspend/:id', :to=>'admin#suspendUser'
    get 'unsuspend/:id', :to=>'admin#unsuspendUser'
  end

  scope 'channel' do
    post '/add', :to=>'channels#createChannel'
    get '/get', :to=>'channels#getYourChannel'
    get '/get/:token', :to=>'channels#getChannelOfUser'
    post '/edit/:id', :to=>'channels#editChannel'
    get '/getone/:token_channel', :to=>'channels#getChannelByToken'
    get '/delete/:id', :to=>'channels#deleteChannel'
    get '/getall', :to=>'channels#getAllChannels'
    get '/search/:any', :to=>'channels#searchChannel'
    get '/getyoursub/:id', :to=>'channels#getSubscribersToYourChannel'
    get '/checkusersub/:token_channel', :to=>'channel#checkSubscription'
  end

  scope 'sub' do
    get '/add/:id', :to=>'subscription#addSub'
    get '/remove/:id', :to=>'subscription#deleteSub'
    get '/get', :to=>'subscription#viewSub'
  end

  scope 'podcast' do
    post '/add/:id', :to=>'podcast#addPodcast'
    get '/getall', :to=>'podcast#getAllPodcast'
    get '/get/:token_channel', :to=>'podcast#getPodCastInChannel'
    post '/edit/:id', :to=>'podcast#editPodcast'
    get '/delete/:id', :to=>'podcast#deletePodcast'
    get '/listen/:token', :to=>'podcast#ListenToPodcast'
    get '/history/:id', :to=>'podcast#viewListenHistory'
    get '/search/:any', :to=>'podcast#searchPodcast'
  end

  scope 'video' do
    post '/add/:id', :to=>'videos#createVideo'
  end
end
