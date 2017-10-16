class AnswersController < ApplicationController
  respond_to :js
  before_action :find_question
  before_action :authenticate_user!, only: [:create, :update]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answers = @question.answers.all.order('id DESC')

    if @answer.save
      respond_with @answer, location: -> { @answer.question }
    else
      render 'create.js.erb'
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @answers = @question.answers.all.order('id DESC')

    respond_with @answer, location: -> { @answer.question }
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
