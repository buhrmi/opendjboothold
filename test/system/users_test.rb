require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase

  test 'can log in and out' do
    visit '/'
    click_on 'Log in'
    assert_text 'Log out'
    click_on 'Log out'
    assert_text 'Log in'
  end
end