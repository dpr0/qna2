class Api::V1::ProfilesController < Api::V1::BaseController

  authorize_resource class: User

  # Method: POST
  # URL: http://localhost:3000/oauth/token
  #  RequestHeader: Content-Type
  # Value: application/x-www-form-urlencoded
  # client_id= 'Application Id' &
  # client_secret= 'Secret' &
  # code= 'Authorization code' &
  # grant_type=authorization_code&
  # redirect_uri=urn:ietf:wg:oauth:2.0:oob

  def me # http://localhost:3000/api/v1/profiles/me.json?access_token=
    respond_with current_resource_owner
  end

  def index # http://localhost:3000/api/v1/profiles/users.json?access_token=
    respond_with User.where.not('id = ?', current_resource_owner.id)
  end

end
