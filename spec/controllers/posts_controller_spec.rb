# frozen_string_literal: true

# spec/controllers/post_objects_controller_spec.rb
require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin_level: 1) }
  let(:post_object) { create(:post, author: user) }

  before do
    allow(controller).to receive(:authorized_user?).and_return(true)
    allow(controller).to receive(:authorized_admin?).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'returns post_object and comments' do
      get :show, params: { id: post_object.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    let(:forum) { create(:forum) }
    it 'creates a new post' do
      post_object_params = attributes_for(:post).merge(forum_id: forum.id)
      expect { post :create, params: { post: post_object_params } }.to change(Post, :count).by(1)
    end
  end

  describe 'PUT #update' do
    it 'updates the post_object' do
      put :update, params: { id: post_object.id, post: { title: 'Updated' } }
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the post_object' do
      delete :destroy, params: { id: post_object.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT #lock_post_object' do
    it 'toggles lock status' do
      put :lock_post, params: { id: post_object.id }
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT #pin_post_object' do
    it 'toggles pin status' do
      put :pin_post, params: { id: post_object.id }
      expect(response).to have_http_status(200)
    end
  end
end
