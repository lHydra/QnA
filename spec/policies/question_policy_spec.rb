require 'rails_helper'

describe QuestionPolicy do
  subject { QuestionPolicy.new(author, question) }

  context 'for a visitor' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { should_not authorize(:update)  }
    it { should_not authorize(:edit)    }
    it { should_not authorize(:destroy) }
  end

  context 'for a author' do
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }

    it { should authorize(:update)  }
    it { should authorize(:edit)    }
    it { should authorize(:destroy) }
  end
end
