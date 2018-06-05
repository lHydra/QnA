FactoryGirl.define do
  factory :attachment_on_question, class: Attachment do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'attachments', 'logo-image.jpg'), 'image/jpeg') }
    association :attachmentable, factory: :question
  end

  factory :attachment_on_answer, class: Attachment do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'attachments', 'logo-image.jpg'), 'image/jpeg') }
    association :attachmentable, factory: :answer
  end
end
