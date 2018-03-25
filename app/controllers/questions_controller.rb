class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :authorization_filter, only: [:edit, :update]

  respond_to :html

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers.all.order('id DESC')
    @attachments = @question.attachments
    @answer.attachments.build
    respond_with @question
  end

  def new
    @question = Question.new
    @question.attachments.build
    respond_with @question
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    @question.save
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def authorization_filter
    if current_user != Question.find(params[:id]).user
      redirect_to questions_path, notice: 'You don`t have enough rights'
    end
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file])
  end
end
