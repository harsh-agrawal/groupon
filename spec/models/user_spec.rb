require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  let(:factory_instance) { build(:user_with_order) }
  let(:factory_instance_deal) { build(:deal_with_order) }

  describe "ActiveModel validations" do
    it { should have_secure_password }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:first_name).is_at_most(50) }
    it { should validate_length_of(:last_name).is_at_most(50) }
    it { should validate_length_of(:password).is_at_least(6) }

    it { should allow_value('abc12@xyz.com').for(:email) }
    it { should_not allow_value('abc@xyzcom').for(:email).with_message('Invalid Format') }
    it { should_not allow_value('abcxyz.com').for(:email).with_message('Invalid Format') }
  end

  describe "ActiveRecord associations" do
    it { should have_many(:orders).dependent(:restrict_with_error) }
    it { should have_many(:payment_transactions).dependent(:restrict_with_error) }
  end

  context "callbacks" do
    it { is_expected.to callback(:set_and_generate_verification_token).before(:create).unless(:admin?) }
    it { is_expected.to callback(:send_verification_mail).after(:commit).on(:create).unless(:admin?) }
    it { is_expected.to callback(:set_password_required).before(:validation).on(:create) }
  end

  describe "public instance methods" do
    context "responds to its methods" do
      it { expect(factory_instance).to respond_to(:valid_verification_token?) }
      it { expect(factory_instance).to respond_to(:valid_forgot_password_token?) }
      it { expect(factory_instance).to respond_to(:change_password) }
      it { expect(factory_instance).to respond_to(:verify!) }
      it { expect(factory_instance).to respond_to(:set_forgot_password_token!) }
      it { expect(factory_instance).to respond_to(:set_remember_token) }
      it { expect(factory_instance).to respond_to(:clear_remember_token!) }
      it { expect(factory_instance).to respond_to(:qty_can_be_purchased) }
      it { expect(factory_instance).to respond_to(:generate_token) }
    end

    context "executes methods correctly" do

      context "#set_remember_token" do
        it "generates the remember token" do
          factory_instance.set_remember_token
          expect(factory_instance.remember_token).to_not be_nil
        end
      end

      context "#clear_remember_token!" do
        it "sets the remember token to nil" do
          factory_instance.clear_remember_token!
          expect(factory_instance.remember_token).to be_nil
        end
      end

      context "#verify!" do
        before :each do
          factory_instance.save
          factory_instance.verify!
        end

        it "sets the verification token to nil" do
          expect(factory_instance.verification_token).to be_nil
        end

        it "sets the verification token expire at to nil" do
          expect(factory_instance.verification_token_expire_at).to be_nil
        end

        it "generates authentication token" do
          expect(factory_instance.authentication_token).to_not be_nil
        end
      end

      context "#qty_can_be_purchased" do
        it "dsiplay the available quantity of the deal" do
          factory_instance.save
          factory_instance_deal.save
          expect(factory_instance.qty_can_be_purchased(factory_instance_deal)).to eq(3)
        end
      end

      context "#change_password" do
        before :each do
          factory_instance.change_password('asdfgh', 'asdfgh')
        end

        it "sets the password to the corresponding arguement" do
          expect(factory_instance.password).to eq('asdfgh')
        end

        it "sets the confirm password to the crresponding arguement" do
          expect(factory_instance.password_confirmation).to eq('asdfgh')
        end

        it "sets password required to true" do
          expect(factory_instance.password_required).to be true
        end

        it "sets forgot password token to nil" do
          expect(factory_instance.forgot_password_token).to be_nil
        end

        it "sets forgot password expire at nil" do
          expect(factory_instance.forgot_password_expire_at).to be_nil
        end
      end

      context "#valid_verification_token?" do
        it "checks the validity of verification token" do
          factory_instance.verification_token_expire_at = Time.current + 2.days
          expect(factory_instance.valid_verification_token?).to be true
        end
      end

      context "#valid_forgot_password_token?" do
        it "checks the validity of forgot password token" do
          factory_instance.forgot_password_expire_at = Time.current + 2.days
          expect(factory_instance.valid_forgot_password_token?).to be true
        end
      end

      context "#set_forgot_password_token!" do
        before :each do
          factory_instance.set_forgot_password_token!
        end

        it "generates forgot password token" do
          expect(factory_instance.forgot_password_token).to_not be_nil
        end

        it "sets token expiry" do
          expect(factory_instance.forgot_password_expire_at).to_not be_nil
        end
      end

    end

  end



end
