class AnswersController < ApplicationController
  respond_to :html, :js
  before_action :find_question
  before_action :authenticate_user!, only: [:create, :update]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
    @answers = @question.answers.all.order('id DESC')

    respond_with @answer.question
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @answers = @question.answers.all.order('id DESC')

    respond_with @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
