include ApplicationHelper

def sign_in(user)
	visit signin_path
	fill_in "Login", 	with: user.email
	fill_in "Password",	with: user.password
	click_button "Sign in"
	# other stuff
	cookies[:remember_token] = user.remember_token
end

def valid_signin(user)
  fill_in "Login",		with: user.email
  fill_in "Password", 	with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end