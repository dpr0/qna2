require 'rails_helper'

RSpec.describe AttachesController, type: :controller do

  let(:user)    { create(:user) }
  let(:question){ create(:question, user: user) }
  let(:answer)  { create(:answer, user: user, question: question) }
  let(:q_attach){ create(:attach, attachable: question) }
  let(:a_attach){ create(:attach, attachable: answer) }
  
  describe 'DELETE #destroy' do
    context 'author of the question' do
    	before { sign_in(q_attach.attachable.user) }
	    it 'deletes q_attach' do    
	        expect { delete :destroy, id: q_attach, format: :js }.to change(Attach, :count).by(-1)
	    end
	    it 'render template Destroy' do
	        delete :destroy, id: q_attach, format: :js
	        expect(response).to render_template :destroy
	    end
	end
	context 'author of the answer' do
		before { sign_in(a_attach.attachable.user) }
	    it 'deletes a_attach' do    
	        expect { delete :destroy, id: a_attach, format: :js }.to change(Attach, :count).by(-1)
	    end
	    it 'render template Destroy' do
	        delete :destroy, id: a_attach, format: :js
	        expect(response).to render_template :destroy
	    end
	end


  end
end
