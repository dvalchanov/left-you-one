Rails.application.routes.draw do
  constraints ->(_request) { Rails.env.development? || Rails.env.test? } do
    namespace :dev do
      get "recipient-lab", to: "recipient_labs#show", as: :recipient_lab
      get "recipient-preview", to: "recipient_previews#show", as: :recipient_preview
      post "prototype-visual-default", to: "prototype_visual_defaults#create", as: :prototype_visual_default
      delete "gifts/:public_slug", to: "gifts#destroy", as: :gift
    end
  end

  get "start", to: "starts#show", as: :start
  post "gifts", to: "gifts#create", as: :gifts

  get "manage/:token", to: "creator_capabilities#show", as: :creator_capability
  get "gifts/:public_slug/manage", to: "managed_gifts#show", as: :managed_gift
  post "gifts/:public_slug/reveal", to: "managed_gifts#reveal", as: :reveal_managed_gift
  post "gifts/:public_slug/recipient", to: "managed_gifts#recipient", as: :recipient_managed_gift
  post "gifts/:public_slug/activate", to: "managed_gifts#activate", as: :activate_managed_gift
  post "gifts/:public_slug/cancel", to: "managed_gifts#cancel", as: :cancel_managed_gift
  get "gifts/:public_slug/recipient-preview", to: "managed_gifts#recipient_preview", as: :recipient_preview_managed_gift

  get "open/:token", to: "recipient_claims#show", as: :open_claim
  post "open/:token/claim", to: "recipient_claims#create", as: :claim_transfer
  get "hold/:token", to: "holder_capabilities#show", as: :holder_capability

  get "o/:public_slug", to: "public_gifts#show", as: :public_gift
  patch "o/:public_slug/holder_identity", to: "public_gifts#holder_identity", as: :holder_identity

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
