class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:destroy, :update, :best]

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy if @answer.user_id == current_user.id
  end

  def best
    # знаю что это ошибка, писать лучший ответ в контроллере,
    # т.к. fat model - slim controller,
    # но... пока не знаю как работают транзакции в модели как других коллег
    # и пробовал передавать это через $глобальную переменную - все работает
    # это скорее всего тоже не правильно, но работает.
    # Виталик напиши почему так нельзя и говнокод ли это
    # (критику воспринимаю положительно)
    @question = @answer.question
    @oldbest = @answer.question.answers.find_by(best: 1)
    @oldbest.update_attributes(best: 0) if @oldbest
    @answer.update_attributes(best: 1)
    #$answer = @answer
    #$answer.best_answer
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
