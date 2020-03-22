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
    get '/video/history', :to=>'user#getVideoHostory'
    get '/notifvideo', :to=>'user#getNotificationVideo'
    get '/notifpodcast', :to=>'user#getNotificationPodcast'
    get '/notilength', :to=>'user#getNotificationLength'
    get '/userpodcastvideolength', :to=>'user#LengthOfUserVideoPodcast'
  end


  scope 'login' do
    post '/user', :to=>'auth#login'
    post '/admin', :to=>'auth#adminLogin'
  end

  
  

  scope 'channel' do
    post '/add', :to=>'channels#createChannel'
    get '/get', :to=>'channels#getYourChannel'
    get '/get/:token', :to=>'channels#getChannelOfUser'
    post '/edit/:id', :to=>'channels#editChannel'
    get '/getonechannel/:token_channel', :to=>'channels#getChannelByToken'
    get '/delete/:id', :to=>'channels#deleteChannel'
    get '/getall', :to=>'channels#getAllChannels'
    get '/search/:any', :to=>'channels#searchChannel'
    get '/getyoursub/:id', :to=>'channels#getSubscribersToYourChannel'
    get '/checkusersub/:token_channel', :to=>'channels#checkSubscription'
    post '/updateimage/:id', :to=>'channels#updateChannelImage'
    get '/getpodcast', :to=>'channels#getPodcastChannel'
    get '/getvideo', :to=>'channels#getVideoChannel'
    get '/myvideo', :to=>'channels#getYourVideoChannel'
    get '/mypodcast', :to=>'channels#getYourPodcastChannel'
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
    get '/mostlistens', :to=>'podcast#getMostListens'
    get '/feed', :to=>'podcast#PodcastFeed'
  end

  scope 'video' do
    post '/add/:id', :to=>'videos#createVideo'
    get '/getall', :to=>'videos#getAllVideos'
    get '/get/:token_channel', :to=>'videos#getVideoInChannel'
    post '/edit/:id', :to=>'videos#editVideo'
    get '/delete/:id', :to=>'videos#deleteVideo'
    get '/search/:any', :to=>'videos#searchVideo'
    get '/getvid/:token', :to=>'videos#getVideoByToken'
    get '/history/:id', :to=>'videos#getViewHistory'
    get '/mostviews', :to=>'videos#getMostViewed'
    get '/feed', :to=>'videos#getVideoFeed'
  end

  scope 'podcomment' do
    post '/add/:id', :to=>'podcastcomment#addComment'
    get '/delete/:id', :to=>'podcastcomment#deleteComment'
    get '/get/:token', :to=>'podcastcomment#getCommentinPodcast'
  end

  scope 'vidcomment' do
    post '/add/:id', :to=>'videocomment#addComment'
    get '/delete/:id', :to=>'videocomment#deleteComment'
    get '/get/:token', :to=>'videocomment#getCommentinVideo'
  end

  scope 'vidreply' do
    post '/add/:id', :to=>'videoreply#replyTocomment'
    get '/delete/:id', :to=>'videoreply#deleteReply'
  end

  scope 'podreply' do
    post '/add/:id', :to=>'podcastreply#replyTocomment'
    get '/delete/:id', :to=>'podcastreply#deleteReply'
  end

  scope 'report' do
    post '/video/:id', :to=>'report#reportVideo'
    post '/podcast/:id', :to=>'report#reportPodcast'
  end

  scope 'bookmark' do
    get '/video/:id', :to=>'bookmark#BookmarkVideo'
    get '/podcast/:id', :to=>'bookmark#BookmarkPodcast'
    get '/videoget', :to=>'bookmark#UserVideoBookmarks'
    get '/podcastget', :to=>'bookmark#UserPodcastBookmarks'
    get '/checkvideo/:token', :to=>'bookmark#checkVideoBookmark' 
    get '/checkpodcast/:token', :to=>'bookmark#checkPodcastBookmark'
    get '/removevideo/:id', :to=>'bookmark#removeVideoBookmark'
    get '/removepodcast/:id', :to=>'bookmark#removedPodcastBookmark'
  end

  namespace :admin do
    get '/getusers', :to => "admin#getAllUsers"
    get '/makeadmin/:id', :to=>'admin#makeAdmin'
    get '/removeadmin/:id', :to=>'admin#removeAdmin'
    get '/suspend/:id', :to=>'admin#suspendUser'
    get '/unsuspend/:id', :to=>'admin#unsuspendUser'
    get '/suspendvideo/:id', :to=>'uploads#suspend_video'
    get '/unsuspendvideo/:id', :to=>'uploads#unsuspend_video'
    get '/suspendpodcast/:id', :to=>'uploads#suspend_podcast'
    get 'unsuspendpodcast/:id', :to=>'uploads#unsuspend_podcast'
    get '/videoreport/:token', :to=>'reports#getVideoReport'
    get '/podcastreport/:token', :to=>'reports#getPodcastReport'
    get '/search/user/:any', :to=>'admin#SearchUser'
    get '/getvideo/:token', :to=>'uploads#getVideoByToken'
    get '/getpocast/:token', :to=>"uploads#ListenToPodcast"
    get '/getallvideos', :to=>"uploads#getAllVideos"
    get '/searchvideo/:any', :to=>"uploads#searchVideo"
    get '/getallpodcast', :to=>"uploads#getAllPodcast"
    get 'searchpodcast/:any', :to=>"uploads#searchPodcast"
  end

end
