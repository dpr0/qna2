class Api::V1::QuestionsController < Api::V1::BaseController

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

  def index # http://localhost:3000/api/v1/questions.json?access_token=
    @questions = Question.all
    #respond_with @question.to_json(include: :answers)
    respond_with @questions, each_serializer: QuestionSerializer
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, serializer: QuestionSerializer
  end

  def create
    #respond_with(@question = current_user.questions.create(question_params))
    @question = Question.create(question_params.merge(user: current_resource_owner))
    respond_with @question

    #respond_with current_resource_owner.questions.create(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attaches_attributes: [:id, :file, :_destroy])
  end

end