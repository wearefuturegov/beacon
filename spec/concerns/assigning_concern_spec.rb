# frozen_string_literal: true

require 'rails_helper'

class ExampleAssigningConcern < ApplicationController
  include AssigningConcern
end

RSpec.describe ExampleAssigningConcern do
  describe 'roles assignments' do
    before :each do
      Rails.cache.clear
      # roles
      roles = [Role.new(id: 1, name: 'mdt')]
      role_class = class_double(Role).as_stubbed_const
      allow(role_class).to receive(:all).and_return(role_class)
      allow(role_class).to receive(:order).and_return(roles)
    end

    it 'populates assignable users options' do
      # users
      users = [User.new(id: 1, first_name: 'User', last_name: 'Test', email: 'user1@test.com'), User.new(id: 1, first_name: 'User', last_name: 'Test', email: 'user1@test.com', deleted_at: DateTime.now)]
      user_class = class_double(User).as_stubbed_const
      allow(user_class).to receive(:all).and_return(user_class)
      allow(user_class).to receive(:with_deleted).and_return(user_class)
      allow(user_class).to receive(:order).and_return(users)

      # populates the users list with active users only
      options = subject.construct_assigned_to_options

      expect(user_class).not_to receive(:with_deleted)
      expect(options).to eq('Teams' => [['mdt', 'role-1']],
                            +'Users' => [['User Test', 'user-1']])
    end

    it 'populates users options' do
      # users
      users = [User.new(id: 1, first_name: 'User', last_name: 'Test', email: 'user1@test.com', deleted_at: DateTime.now)]
      user_class = class_double(User).as_stubbed_const
      allow(user_class).to receive(:all).and_return(user_class)
      allow(user_class).to receive(:with_deleted).and_return(user_class)
      allow(user_class).to receive(:order).and_return(users)

      # populates the users list including deleted users
      options = subject.construct_assigned_to_options true

      expect(options).to eq('Teams' => [['mdt', 'role-1']],
                            +'Users' => [['User Test [X]', 'user-1']])
    end
  end
end
