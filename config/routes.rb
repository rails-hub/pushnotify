Pushnotify::Application.routes.draw do
  match 'api/register' => 'user#register_api', via: [:post]

  root to: "home#index"

end
