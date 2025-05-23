# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Bookmarks' do
  it 'shows bookmarks as checkboxes', :js do
    visit solr_document_path('aoa271_aspace_a951375d104030369a993ff943f61a77')
    check 'Bookmark'
    click_on 'Bookmarks'

    visit solr_document_path('aoa271_aspace_a951375d104030369a993ff943f61a77')
    expect(page).to have_css('input[type="checkbox"][checked]')
    uncheck 'In Bookmarks'
  end
end
