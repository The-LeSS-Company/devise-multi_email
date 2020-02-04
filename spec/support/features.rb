module RailsTestHelpers
  def generate_email
    "user_#{SecureRandom.hex}@test.com"
  end

  def create_user(options={})
    user = User.create!(
        username: 'usertest',
        email: options[:email] || generate_email,
        password: options[:password] || '12345678',
        password_confirmation: options[:password] || '12345678',
        created_at: Time.now.utc
    )
    user.emails.first.update_attribute(:confirmation_sent_at, options[:confirmation_sent_at]) if options[:confirmation_sent_at]
    user.confirm unless options[:confirm] == false
    user
  end

  def create_email(user, options = {})
    email_address = options[:email] || generate_email
    user.multi_email.find_or_build_for_email(email_address)

    email = user.emails.to_a.find { |record| record.email == email_address }
    email.update_attribute(:confirmation_sent_at, options[:confirmation_sent_at]) if options[:confirmation_sent_at]
    email.update_attribute(:primary_candidate, options[:primary_candidate]) if options[:primary_candidate]

    if options[:confirm] == false
      user.save
    else
      email.confirm
    end

    email
  end

  def sign_in_as_user(options={}, &block)
    user = create_user(options)
    visit_with_option options[:visit], new_user_session_path
    fill_in 'email', with: options[:email] || 'user@test.com'
    fill_in 'password', with: options[:password] || '12345678'
    check 'remember me' if options[:remember_me] == true
    yield if block_given?
    click_button 'Log In'
    user
  end
end

RSpec.configure do |config|
  config.include RailsTestHelpers
end
