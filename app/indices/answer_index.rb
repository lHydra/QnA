ThinkingSphinx::Index.define :answer, with: :active_record do
  # fields
  indexes body
  indexes user.email, as: :author, sortable: true
  indexes question.title, as: :question, sortable: true

  # attributes
  has created_at, updated_at, question_id, user_id
end
