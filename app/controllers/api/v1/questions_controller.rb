class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end

  def create
    @question = QuestionForm.new(question_params)
    @question.user_id = current_resource_owner.id
    @question.save
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
