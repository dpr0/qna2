class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!
  authorize_resource class: User
  respond_to :json

  # Method: POST
  # http://localhost:3000/oauth/applications/1
  # RequestHeader: Content-Type
  # Value: application/x-www-form-urlencoded
  # client_id= 'Application Id' &
  # client_secret= 'Secret' &
  # code= 'Authorization code' &
  # grant_type=authorization_code&
  # redirect_uri=urn:ietf:wg:oauth:2.0:oob

  def me # http://localhost:3000/api/v1/profiles/me.json?access_token=
    respond_with current_resource_owner
  end

  def users # http://localhost:3000/api/v1/profiles/users.json?access_token=
    respond_with User.where.not('id = ?', current_resource_owner.id)
  end

  protected

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner)
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
