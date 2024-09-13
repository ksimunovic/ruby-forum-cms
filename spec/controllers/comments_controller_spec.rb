# frozen_string_literal: true

# spec/controllers/comments_controller_spec.rb
require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user, token: 'valid_token', token_date: Time.now) }
  let!(:admin) { create(:user, token: 'admin_token', token_date: Time.now, admin_level: 1) }
  let!(:post_object) { create(:post) }
  let!(:comment) { create(:comment, post: post_object, author: user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(CommentsController).to receive(:authorized_user?).and_return(true)
  end

  describe 'GET #show' do
    it 'returns the comment' do
      get :show, params: { id: comment.id }
      expect(response).to have_http_status(:ok)
      expect(json_response[:comment][:id]).to eq(comment.id)
    end
  end

  describe 'POST #create' do
    context 'when user is suspended' do
      it 'returns an error message' do
        user.update(can_comment_date: 1.day.from_now)
        post :create, params: { comment: { body: 'Test comment', post_id: post_object.id, user_id: user.id } }
        expect(response).to have_http_status(:ok)
        expect(json_response[:errors]).to include('Your commenting communications are still suspended')
      end
    end

    context 'when user is not suspended' do
      it 'creates a comment' do
        post :create, params: { comment: { body: 'Test comment', post_id: post_object.id, user_id: user.id } }
        expect(response).to have_http_status(:ok)
        expect(json_response[:comment][:body]).to eq('Test comment')
      end
    end
  end

  describe 'PUT #update' do
    context 'when unauthorized' do
      it 'returns an unauthorized message' do
        another_user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(another_user)
        put :update, params: { id: comment.id, comment: { body: 'Updated body' } }
        expect(response).to have_http_status(401)
        expect(json_response[:errors]).to include('Account not Authorized')
      end
    end

    context 'when authorized' do
      it 'updates the comment' do
        put :update, params: { id: comment.id, comment: { body: 'Updated body' } }
        expect(response).to have_http_status(:ok)
        expect(json_response[:comment][:body]).to eq('Updated body')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when unauthorized' do
      it 'returns an unauthorized message' do
        another_user = create(:user)
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(another_user)
        delete :destroy, params: { id: comment.id }
        expect(response).to have_http_status(401)
        expect(json_response[:errors]).to include('Account not Authorized')
      end
    end

    context 'when authorized' do
      it 'deletes the comment' do
        expect do
          delete :destroy, params: { id: comment.id }
        end.to change(Comment, :count).by(-1)
        expect(response).to have_http_status(:ok)
        expect(json_response[:message]).to eq('Comment deleted')
      end
    end
  end
end
