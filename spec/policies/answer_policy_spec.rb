require 'rails_helper'

RSpec.describe Answer do 
  subject { AnswerPolicy.new(user, answer) }

  context 'for a visitor' do
    let(:user) { nil }
    let(:answer) { create(:answer) }

    it { should_not authorize(:update) }
  end

  context 'for a author' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: user) }
    
    it { should authorize(:update) }
  end
end
