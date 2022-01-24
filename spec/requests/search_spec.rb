require 'rails_helper'

RSpec.describe "Searches", type: :request do

  context "GET search repositories" do
    
    it 'should show index/search page' do 
      get '/'
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end 
  
    it 'should show page with finded repos related to Ruby' do
      get '/', :params => {search: 'ruby'}
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end
  
  context "GET search repositories with pages" do
    it 'should find repositories at 25 page' do 
      get '/', :params => {search: 'ruby', page: 25}
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
      expect(request.params['page']).to eq "25"
    end
  end
  
  
end
