Pushnotify::Application.routes.draw do
  match 'api/register' => 'user#register_api', via: [:post]
  match 'api/notify' => 'user#notify_api', via: [:get]

  root to: "home#index"

end
