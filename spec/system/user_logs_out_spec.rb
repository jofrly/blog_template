require 'rails_helper'

RSpec.describe 'User logs out' do
  before do
    driven_by(:rack_test)
  end

  it 'successfully' do
    create_user_and_login

    click_link 'Abmelden'

    expect(page).not_to have_link 'Abmelden'
  end
end
