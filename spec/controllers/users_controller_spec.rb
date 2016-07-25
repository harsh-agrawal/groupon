require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { build(:user) }
  let(:invalid_user) { build(:invalid_user) }
  let(:unverified_user) { create(:unverified_user) }

  describe 'GET#new' do
    def send_request
      get :new
    end

    it 'checks if the user is logged in or not' do
      controller.class.before_action(:ensure_anonymous)
    end

    context 'user is logged in' do
      before :each do
        user.save!
        login_user(user)
        send_request
      end

      it 'should redirect to home page' do
        expect(response).to redirect_to(root_path)
      end

      it 'should dsiplay flash message' do
        expect(flash[:notice]).to eq 'Your are not allowed to access this page.'
      end

      it 'returns a redirection code' do
        expect(response).to have_http_status(302)
      end
    end

    context 'user is not logged in' do
      before :each do
        send_request
      end

      it 'renders new' do
        expect(response).to render_template("new")
      end

      it 'returns a success code' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'POST#create' do
    def send_request_with_valid_attributes
      post :create, user: attributes_for(:user)
    end

    def send_request_with_invalid_attributes
      post :create, user: attributes_for(:invaild_user)
    end

    context 'user is logged in' do
      before :each do
        user.save!
        login_user(user)
        send_request_with_valid_attributes
      end

      it 'should redirect to home page' do
        expect(response).to redirect_to(root_path)
      end

      it 'should dsiplay flash message' do
        expect(flash[:notice]).to eq 'Your are not allowed to access this page.'
      end

      it 'returns a redirection code' do
        expect(response).to have_http_status(302)
      end
    end

    context 'user is not logged in' do

      context 'valid attributes for user' do
        before :each do
          send_request_with_valid_attributes
        end
        it 'should redirect to home page' do
          expect(response).to redirect_to(root_path)
        end

        it 'should display flash message of successful creation of user' do
          expect(flash[:alert]).to eq "Please confirm your email address to continue. User #{user.first_name} was successfully created."
        end

        it 'returns a redirection code' do
          expect(response).to have_http_status(302)
        end
      end

      context 'invalid attributes for user' do
        before :each do
          send_request_with_invalid_attributes
        end

        it 'renders new' do
          expect(response).to render_template("new")
        end

        it 'returns a success code' do
          expect(response).to have_http_status(200)
        end
      end

    end
  end

  describe 'GET#account_activation' do

    def send_request_with_invalid_verification_token
      get :account_activation, token: '7adfh5586'
    end

    def send_request_with_valid_verification_token
      get :account_activation, token: 'adfh5586'
    end

    context 'invalid verification token' do
      before :each do
        unverified_user.update_attribute(:verification_token, 'adfh5586')
        send_request_with_invalid_verification_token
      end

      it 'should redirect to home page' do
        expect(response).to redirect_to(root_path)
      end

      it 'should display flash message of invalid url' do
        expect(flash[:notice]).to eq 'Invalid URL.'
      end

      it 'returns a redirection code' do
        expect(response).to have_http_status(302)
      end
    end

    context 'valid verification token' do
      before :each do
        unverified_user.update_attribute(:verification_token, 'adfh5586')
        send_request_with_valid_verification_token
      end

      it "should call sign_in with appropriate arguments" do
        controller.view_context.sign_in(unverified_user).should == true
        # expect(controller.view_context).to receive(:sign_in).with(unverified_user).and_return(true)
      end

      it 'should redirect to home page' do
        expect(response).to redirect_to(root_path)
      end

      it 'should display the flash message to welcome user' do
        expect(flash[:notice]).to eq 'Welcome to the Groupon! Your email has been confirmed.'
      end

      it 'returns a redirection code' do
        expect(response).to have_http_status(302)
      end

    end
  end
end
