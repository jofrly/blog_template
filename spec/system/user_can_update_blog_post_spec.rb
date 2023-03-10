require 'rails_helper'

RSpec.describe 'User can update blog post' do
  before do
    driven_by(:selenium_headless)
  end

  it 'successfully' do
    create_user_and_login
    create(:post, title: 'First post', content: 'This is the content of the first post.')
    visit root_path
    click_link 'First post'
    click_link 'Bearbeiten'
    fill_in 'Titel', with: 'Updated title'
    fill_in 'Slug (optional)', with: 'updated-custom-slug'
    fill_in_trix_editor 'Updated content'
    click_button 'Speichern'
    expect(page).to have_current_path(blog_post_path('updated-custom-slug'), ignore_query: true)
    expect(page).to have_text('Updated title')
    expect(page).to have_text('Updated content')
  end

  it 'unsuccessfully' do
    create_user_and_login
    post = create(:post, title: 'First post', content: 'This is the content of the first post.')
    visit root_path
    click_link 'First post'
    click_link 'Bearbeiten'
    fill_in 'Titel', with: ''
    clear_trix_editor
    click_button 'Speichern'
    expect(page).to have_current_path(edit_blog_post_path(post), ignore_query: true)
    expect(page).to have_text('Titel muss ausgefüllt werden')
    expect(page).to have_text('Inhalt muss ausgefüllt werden')
  end

  it 'can cancel' do
    create_user_and_login
    post = create(:post, title: 'First post', content: 'This is the content of the first post.')
    visit root_path
    click_link 'First post'
    click_link 'Bearbeiten'
    click_link 'Abbrechen'
    expect(page).to have_current_path(blog_post_path(post), ignore_query: true)
  end
end
