Rails.application.routes.draw do
  root "dns#index"  # Main page
  get "/lookup", to: "dns#lookup"  # API for DNS lookup
end
