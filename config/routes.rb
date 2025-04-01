# frozen_string_literal: true

Rails.application.routes.draw do
  # Route helpers
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  concern :searchable, Blacklight::Routes::Searchable.new
  concern :exportable, Blacklight::Routes::Exportable.new
  concern :hierarchy, Arclight::Routes::Hierarchy.new

  # Engines
  mount Blacklight::Engine => '/'
  mount BlacklightDynamicSitemap::Engine => '/'
  mount Arclight::Engine => '/'
  
  #Route Helpers
  require 'sidekiq/web'
  mount Sidekiq::Web => '/queues'

# KSUL CUSTOMIZATION: note that component URLs have underscores; collections don't
 def collection_slug_constraint
  /[A-Za-z0-9\-_.]+/  # Includes upper/lowercase, dashes, dots, and underscores
end

  # Homepage
  root to: 'pages#home'

  # Catalog index (search landing page)
  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
    concerns :range_searchable
  end

  devise_for :users

  # XML Download Route - must come BEFORE solr_documents so it's not overridden
  get '/catalog/:id/xml', to: 'catalog#ead_download', as: 'ead_download',
                          constraints: { id: collection_slug_constraint }

  # Solr document route (includes support for slashes in IDs)
  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog',
                            constraints: { id: /[^\/]+(?:\/[^\/]+)*/ } do
    concerns :hierarchy
    concerns :exportable
  end

  # Bookmarks
  resources :bookmarks do
    concerns :exportable
    collection { delete 'clear' }
  end

  # UA Record Groups
  resources :ua_record_groups, only: [:index], as: 'ua_record_groups',
            path: '/collections/ua-record-groups', controller: 'ua_record_groups'

  # Sitemap
  get '/custom_sitemaps/:id', controller: 'custom_sitemaps', action: 'index',
      defaults: { format: 'xml' },
      constraints: ->(request) { CUSTOM_SITEMAP_CONFIG.key?(request.params[:id]) }

  # Indexing endpoint
  post '/index_finding_aids', to: 'index_finding_aids#create'

  # Health check
  get 'up', to: 'rails/health#show', as: :rails_health_check
end
