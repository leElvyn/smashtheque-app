# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  icon       :string
#  is_main    :boolean
#  latitude   :float
#  longitude  :float
#  name       :string
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_locations_on_type  (type)
#
require 'rails_helper'

RSpec.describe Location, type: :model do

  before(:each) do
    @existing_location = Locations::City.create!(name: 'Paris')
    @new_location = FactoryBot.build(:location)
  end

  context 'is valid' do
    it 'creates the location' do
      expect(@new_location).to be_valid
    end
  end

  context 'is invalid' do
    it 'does not create a location without a name' do
      @new_location.name = ''
      expect(@new_location).to_not be_valid
    end

    it 'does not create a location with an already existing name' do
      @new_location.name = @existing_location.name
      expect(@new_location).to_not be_valid
    end

    it 'does not create a location with a name similar to an existing name' do
      @new_location.name = 'pàris'
      expect(@new_location).to_not be_valid
    end
  end

end
