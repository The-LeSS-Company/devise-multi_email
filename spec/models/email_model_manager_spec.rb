require 'rails_helper'

RSpec.describe Devise::MultiEmail::EmailModelManager, type: :model do
  subject(:user) { create_user }

  let(:new_email) { generate_email }

  it 'should not allow to change confirmed email' do
    expect(user.primary_email_record.update(email: new_email)).to be_falsey
    expect(user.primary_email_record.errors.messages).to include(:email)
  end

end
