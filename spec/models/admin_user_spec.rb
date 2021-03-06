# == Schema Information
#
# Table name: admin_users
#
#  id                 :bigint           not null, primary key
#  current_sign_in_at :datetime
#  current_sign_in_ip :inet
#  encrypted_password :string           default(""), not null
#  is_root            :boolean          default(FALSE), not null
#  last_sign_in_at    :datetime
#  last_sign_in_ip    :inet
#  level              :string           not null
#  sign_in_count      :integer          default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  discord_user_id    :bigint
#
# Indexes
#
#  index_admin_users_on_discord_user_id  (discord_user_id) UNIQUE
#
require 'rails_helper'

RSpec.describe AdminUser, type: :model do

  before(:each) do
    @existing_admin_user = AdminUser.create!(
      discord_user: FactoryBot.create(:discord_user),
      level: Ability::LEVEL_ADMIN
    )
    @other_discord_user = FactoryBot.create(:discord_user)
    @new_admin_user = AdminUser.new(
      discord_user: @other_discord_user,
      level: Ability::LEVEL_ADMIN
    )
  end

  context 'is valid' do
    it 'creates the admin' do
      expect(@new_admin_user).to be_valid
    end
  end

  context 'is invalid' do
    it 'does not create an admin without a discord user' do
      @new_admin_user.discord_user = nil
      expect(@new_admin_user).to_not be_valid
    end

    it 'does not create an admin with an already taken discord user' do
      @new_admin_user.discord_user = @existing_admin_user.discord_user
      expect(@new_admin_user).to_not be_valid
    end

    it 'does not create an admin without a level' do
      @new_admin_user.level = nil
      expect(@new_admin_user).to_not be_valid
    end

    it 'does not create an admin with an invalid level' do
      @new_admin_user.level = 'hello'
      expect(@new_admin_user).to_not be_valid
    end
  end

end
