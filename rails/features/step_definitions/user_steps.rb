Given /^I login with credentials "([^\"]*)" and "([^\"]*)"$/ do |login, password|
  @user = User.find_by_login(login)
  fill_in "login", :with => login
  fill_in "password", :with => password
  click_button "Log in"
end