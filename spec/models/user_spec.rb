require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it { should have_many(:school_admins).class_name('School::Admin').dependent(:destroy) }
    it { should have_many(:schools).through(:school_admins) }
    it { should have_many(:enrollments).dependent(:destroy).with_foreign_key(:student_id) }
    it { should have_many(:approved_batches).through(:enrollments).source(:batch) }
    it { should have_many(:my_courses).through(:approved_batches).source(:course) }
    it { should have_many(:my_schools).through(:my_courses).source(:school) }
  end

  describe 'methods' do
    describe '#add_role' do
      it 'should remove all other roles and add the new role if not already present' do
        user.add_role(:student)
        user.add_role(:school_admin)

        expect(user.roles.count).to eq(1)
        expect(user.has_role?(:school_admin)).to be(true)
      end
    end

    describe '#enrolled_for?' do
      let(:batch) { create(:batch) }

      it 'should return true if the user is enrolled for the batch with approved status' do
        create(:enrollment, batch: batch, student: user, status: 'approved')
        expect(user.enrolled_for?(batch)).to be(true)
      end

      it 'should return false if the user is not enrolled for the batch' do
        expect(user.enrolled_for?(batch)).to be(false)
      end

      it 'should return false if the user is enrolled for the batch with a status other than approved' do
        create(:enrollment, batch: batch, student: user, status: 'pending')
        expect(user.enrolled_for?(batch)).to be(false)
      end
    end

    describe '#request_pending_for?' do
      let(:batch) { create(:batch) }

      it 'should return true if the user has a pending enrollment request for the batch' do
        create(:enrollment, batch: batch, student: user, status: 'pending')
        expect(user.request_pending_for?(batch)).to be(true)
      end

      it 'should return false if the user does not have a pending enrollment request for the batch' do
        expect(user.request_pending_for?(batch)).to be(false)
      end
    end

    describe '#applied_before?' do
      let(:batch) { create(:batch) }

      it 'should return true if the user has a rejected enrollment request for the batch' do
        create(:enrollment, batch: batch, student: user, status: 'rejected')
        expect(user.applied_before?(batch)).to be(true)
      end

      it 'should return false if the user does not have a rejected enrollment request for the batch' do
        expect(user.applied_before?(batch)).to be(false)
      end
    end

    describe '#class_mates_for' do
      let(:batch) { create(:batch) }

      it 'should return other students in the same batch as the user' do
        student1 = create(:user)
        student2 = create(:user)
        create(:enrollment, batch: batch, student: user, status: 'approved')
        create(:enrollment, batch: batch, student: student1, status: 'approved')
        create(:enrollment, batch: batch, student: student2, status: 'approved')

        expect(user.class_mates_for(batch)).to include(student1, student2)
        expect(user.class_mates_for(batch)).not_to include(user)
      end

      it 'should not return students from other batches' do
        another_batch = create(:batch)
        student3 = create(:user)
        create(:enrollment, batch: another_batch, student: student3, status: 'approved')

        expect(user.class_mates_for(batch)).not_to include(student3)
      end
    end
  end
end
