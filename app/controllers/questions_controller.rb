class QuestionsController < ApplicationController
  respond_to :html
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :authorization_filter, only: [:edit, :update]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answers = @question.answers.all.order('id DESC')
    @attachments = @question.attachments
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = Question.create(question_params)
    @question.user = current_user
    @question.save
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    @question.destroy
    respond_with @question
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
