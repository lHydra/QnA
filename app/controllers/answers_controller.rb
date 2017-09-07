class AnswersController < ApplicationController
  respond_to :html, :js

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    respond_with @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
