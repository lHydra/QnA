class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  def create
    @question = Question.find(params[:subscription][:question_id])
    current_user.subscribe!(@question)

    respond_with @question
  end

  def destroy
    @question = Subscription.find(params[:id]).question
    current_user.unsubscribe!(@question)

    respond_with @question
  end
end
