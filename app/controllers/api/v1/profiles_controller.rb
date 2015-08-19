class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  skip_authorization_check

  respond_to :json

  def me #http://localhost:3000/api/v1/profiles/me.json?access_token=
    respond_with current_resource_owner
  end

  def users #http://localhost:3000/api/v1/profiles/users.json?access_token=
    respond_with User.where.not('id = ?', current_resource_owner.id)
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end