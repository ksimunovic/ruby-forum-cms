require 'rails_helper'

RSpec.describe ForumsController, type: :controller do
  let!(:forums) { create_list(:forum, 5) }

  before do
    allow(controller).to receive(:authorized_admin?).and_return(true)
  end

  describe 'GET #index' do
    it 'returns all forums with paginated posts and subforums' do
      get :index, params: { per_page: 5, page: 1 }
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['results']['forums'].length).to eq(5)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { name: 'New Forum', subforums: ['Subforum 1'] } }

    it 'creates a new forum' do
      expect {
        post :create, params: { forum: valid_attributes }
      }.to change(Forum, :count).by(1)
    end

    it 'returns the updated list of forums' do
      post :create, params: { forum: valid_attributes }
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['forums'].length).to eq(Forum.count)
    end
  end

  describe 'PUT #update' do
    let(:forum) { forums.first }
    let(:updated_attributes) { { name: 'Updated Forum Name' } }

    it 'updates the forum' do
      put :update, params: { id: forum.id, forum: updated_attributes }
      forum.reload
      expect(forum.name).to eq('updated forum name')
    end

    it 'returns the updated list of forums' do
      put :update, params: { id: forum.id, forum: updated_attributes }
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['forums'].length).to eq(Forum.count)
    end
  end

  describe 'DELETE #destroy' do
    let(:forum) { forums.first }

    it 'deletes the forum' do
      expect {
        delete :destroy, params: { id: forum.id }
      }.to change(Forum, :count).by(-1)
    end

    it 'returns the updated list of forums' do
      delete :destroy, params: { id: forum.id }
      expect(response).to have_http_status(:ok)

      parsed_response = JSON.parse(response.body)
      expect(parsed_response['forums'].length).to eq(Forum.count)
    end
  end
end