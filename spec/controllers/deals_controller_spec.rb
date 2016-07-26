require 'rails_helper'

RSpec.describe DealsController, type: :controller do

  let(:deal) { FactoryGirl.create(:published_deal) }

  describe 'GET#index' do
    def send_request
      get :index
    end

    before do
      debugger
      send_request
    end

    it 'renders index template' do
      expect(response).to render_template :index
    end

    it 'assigns live deals' do
      expect(assigns(:deals)).to match_array Deal.live
    end
  end

  describe 'GET#past' do
    def send_request
      get :past
    end

    before do
      send_request
    end

    it 'renders past template' do
      expect(response).to render_template :past
    end

    it 'assigns past deals' do
      expect(assigns(:deals)).to match_array Deal.past
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
      debugger
      expect(assigns(:deals)).to match_array Deal.search('qaz')
    end
  end

end
