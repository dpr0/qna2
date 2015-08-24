class Api::V1::AnswersController < Api::V1::BaseController

  authorize_resource

  # Method: GET
  # URL: http://localhost:3000/oauth/token
  # RequestHeader: Content-Type
  #         Value: application/x-www-form-urlencoded
  # client_id= 'Application Id' &
  # client_secret= 'Secret' &
  # code= 'Authorization code' &
  # grant_type=authorization_code&
  # redirect_uri=urn:ietf:wg:oauth:2.0:oob

  def index # http://localhost:3000/api/v1/answers.json?access_token=
    respond_with(@answers = Answer.all)
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer, serializer: AnswerSerializer
  end

  def create
    @question = Question.find(params[:question_id])
    #respond_with(@answer = @question.answers.create(answer_params))
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_resource_owner)))
    #respond_with(@answer = @question.answers.create(answer_params.merge({user_id: current_resource_owner.id})))
  end

  private

  def answer_params
    #params.require(:answer).permit(:body, attaches_attributes: [:id, :file, :_destroy]).merge(user_id: current_user.id)
    params.require(:answer).permit(:body)
  end

end