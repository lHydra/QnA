RSpec.shared_examples 'Object with attachments' do
  context 'with attachments' do
    it 'included in parent object' do
      expect(response.body).to have_json_size(1).at_path('attachments')
    end

    %w(id file).each do |attr|
      it "attachment object includes #{attr}" do
        expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
      end
    end

    %w(created_at updated_at attachmentable_id attachmentable_type).each do |attr|
      it "attachment object doesn`t include #{attr}" do
        expect(response.body).to_not have_json_path("attachments/0/#{attr}")
      end
    end 
  end
end
