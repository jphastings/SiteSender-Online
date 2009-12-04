ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.apilogin "api/login", :controller => "user_sessions", :action => "new_api"
  map.apilogin "api/mark", :controller => "bookmarks", :action => "add_api"
  
  map.resources :user_sessions
  map.resources :users
  map.resources :bookmarks
  map.resources :home
  map.root :home
end
