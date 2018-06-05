RSpec.shared_examples 'Object with comments' do
  context 'with comments' do
    it 'includes comments' do
      expect(response.body).to have_json_size(1).at_path('comments')
    end

    %w(id body created_at updated_at).each do |attr|
      it "comment object includes #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
      end
    end

    %w(commentable_id commentable_type).each do |attr|
      it "comment object doesn`t include #{attr}" do
        expect(response.body).to_not have_json_path("comments/0/#{attr}")
      end
    end 
  end
end
