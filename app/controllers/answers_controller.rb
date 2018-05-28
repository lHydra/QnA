class AnswersController < ApplicationController
  before_action :find_question, only: :create
  before_action :authenticate_user!
  before_action :load_answer, only: :update

  respond_to :js

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answers = @question.answers.all.order('id DESC')
    @answer.save

    respond_with @answer, location: -> { @answer.question }
  end

  def update
    authorize @answer
    @answer.update(answer_params)

    respond_with @answer
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
