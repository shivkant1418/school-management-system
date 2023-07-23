# spec/models/school/admin_spec.rb
require 'rails_helper'

RSpec.describe School::Admin, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:school) }
  end

  describe 'validations' do
    subject { build(:school_admin) }

    it 'is valid' do
      expect(subject).to be_valid
    end
  end
end
