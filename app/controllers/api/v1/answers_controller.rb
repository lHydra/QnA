class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @answers = Question.find(params[:question_id]).answers
    respond_with @answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    @answer.save

    respond_with @answer
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
