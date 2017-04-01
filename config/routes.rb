Rails.application.routes.draw do
  resources :document_pages
  resources :documents

  root to: 'documents#new'
end
