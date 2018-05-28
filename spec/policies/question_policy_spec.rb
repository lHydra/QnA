require 'rails_helper'

describe QuestionPolicy do
  subject { QuestionPolicy.new(user, question) }

  context 'for a visitor' do
    let(:user) { nil }
    let(:question) { create(:question) }

    it { should_not authorize(:update)  }
    it { should_not authorize(:edit)    }
    it { should_not authorize(:destroy) }
  end

  context 'for a author' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it { should authorize(:update)  }
    it { should authorize(:edit)    }
    it { should authorize(:destroy) }
  end
end
