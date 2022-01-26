require 'rails_helper'

RSpec.describe 'Searches', type: :request do

  before do 
    stub_request(:get, "https://api.github.com/search/repositories?order=desc&page=1&q=ruby&sort=best%20match").to_return(
      status: 200, 
      body: File.read('spec/fixtures/response.json'), 
      headers: {})

    stub_request(:get, "https://api.github.com/search/repositories?order=desc&page=25&q=ruby&sort=best%20match").to_return(
      status: 200, 
      body: File.read('spec/fixtures/response.json'), 
      headers: {})  
  end

  context 'GET search repositories' do
    it 'should show index/search page' do 
      get '/'
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end 
  
    it 'should show page with finded repos related to Ruby' do
      get '/', :params => {search: 'ruby'}
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
      p request.url
    end
  end
  
  context 'GET search repositories with pages' do
    it 'should find repositories at 25 page' do 
      get '/', :params => {search: 'ruby', page: 25}
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
      expect(request.params['page']).to eq "25"
    end
  end

  context "URL" do
    let(:query) {{'order'=> 'desc', 'page' => '25', 'q' =>'ruby', 'sort' => 'best match'}}

    it 'should have correct url query' do 
      get '/', :params => {search: 'ruby', page: 25}
      expect(WebMock).to have_requested(:get ,'https://api.github.com/search/repositories').with(query: hash_including(query))
    end
    
  end
  
  
end
