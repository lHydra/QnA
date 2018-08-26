class QuestionForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :title, :body, :file, :user_id

  validates :title, presence: true
  validates :body, presence: true

  def initialize(params = {})
    if params['id']
      @question = Question.find(params['id'])
      @attachments = @question.attachments.first
      self.user_id = @question.user.id
    end
    self.id = params.fetch(:id, '')
    self.title = params.fetch(:title, '')
    self.body = params.fetch(:body, '')
    self.file = params.fetch(:file, '')
  end

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def update
    if valid?
      update_form!
      true
    else
      false
    end
  end

  def persisted?
    false
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Question')
  end

  private

  def persist!
    @question = Question.create!(title: title, body: body, user_id: user_id)
    save_attachments
  end

  def update_form!
    @question.update_attributes(
      title: self.title,
      body: self.body
      )
    update_attachments
  end

  def update_attachments
    return unless file.present?
    @attachments.update_attributes(
      file: self.file
      )
  end

  def save_attachments
    return unless file.present?
    @attachments = @question.attachments.create!(file: file)
  end
end
