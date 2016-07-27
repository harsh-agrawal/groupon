require 'rails_helper'

RSpec.describe DealsController, type: :controller do

  render_views

  let(:deal) { FactoryGirl.create(:published_deal) }

  describe 'GET#index' do
    def send_request
      get :index
    end

    before do
      deal.start_time = Time.current - 1.day
      send_request
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end

    it 'assigns live deals' do
      expect(assigns(:deals)).to_not be_nil
    end
  end

  describe 'GET#past' do
    def send_request
      get :past
    end

    before do
      deal.expire_time = Time.current - 1.hour
      send_request
    end

    it 'renders past template' do
      expect(response).to render_template :past
    end

    it 'assigns past deals' do
      expect(assigns(:deals)).to_not be_nil
    end
  end

  describe 'GET#search' do
    def send_request
      get :search, search: 'qaz'
    end

    before do
      send_request
    end

    it 'assigns search param to keyword' do
      expect(assigns(:keyword)).to eq 'qaz'
    end

    it 'renders search template' do
      expect(response).to render_template :search
    end

    it 'assigns deals' do
      expect(assigns(:deals)).to_not be_nil
    end
  end

  describe 'GET#refresh' do
    def send_request
      get(:refresh, {id: deal.id, format: :json})
    end


    before do
      send_request
    end

    it 'assigns the deal with the given id if published' do
      expect(assigns(:deal)).to_not be_nil
    end

    it 'renders refresh template' do
      expect(response.body).to eq("{\"quantity_available\":18,\"quantity_sold\":2,\"sold_out\":false,\"expired\":false}")
    end
  end

  describe 'GET#show' do
    def send_request_with_valid_id
      get :show, id: deal.id
    end

    def send_request_with_invalid_id
      get :show, id: deal.id + 10
    end

    context 'deal exists with given id' do
      before do
        send_request_with_valid_id
      end

      it 'assigns the deal with the given id if published' do
        expect(assigns(:deal)).to_not be_nil
      end

      it 'renders show template' do
        expect(response).to render_template :show
      end
    end

    context 'deal does not exists with given id' do
      before do
        send_request_with_invalid_id
      end

      it 'assigns the deal with the given id if published' do
        expect(assigns(:deal)).to be_nil
      end

      it 'redirects to deals index page' do
        expect(response).to redirect_to(deals_path)
      end

      it 'should display flash message regarding non-existence of such deal' do
        expect(flash[:alert]).to eq 'No such Deal exists.'
      end
    end
  end

end
