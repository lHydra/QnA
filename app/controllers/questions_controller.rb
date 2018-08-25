class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build

    respond_with @question
  end

  def new
    @question = QuestionForm.new
  end

  def edit
    authorize @question
  end

  def create
    @question = QuestionForm.new(question_params)
    @question.user_id = current_user.id
    @question.save

    respond_with @question, location: -> { question_path(Question.last) }
  end

  def update
    @question = QuestionForm.new(question_params.merge(id: params[:id]))
    authorize @question
    @question.update

    respond_with @question, location: -> { question_path(@question.id) }
  end

  def destroy
    authorize @question
    respond_with @question.destroy
  end

  def search
    @results = Question.search(params[:q])
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :file)
  end
end
