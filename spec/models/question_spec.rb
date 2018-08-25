require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:attachments) }
  it { should have_many(:comments) }
  it { should have_many(:subscriptions) }
  it { should have_many(:subscribers) }
end
