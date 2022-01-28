require 'rails_helper'

RSpec.describe 'Searches', type: :request do

  before do 
    stub_request(:get, "https://api.github.com/search/repositories?order=desc&page=1&q=ruby&sort=best%20match").to_return(
      status: 200, 
      body: File.read('spec/fixtures/response.json'), 
      headers: {})

    stub_request(:get, "https://api.github.com/search/repositories?order=desc&page=25&q=ruby&sort=best%20match").to_return(
      status: 200, 
      body: File.read('spec/fixtures/response_page_25.json'), 
      headers: {})
    
    stub_request(:get, "https://api.github.com/search/repositories?order=desc&page=20&q=ruby&sort=best%20match").to_return(
      status: [500, "Internal Server Error"])  
      
    stub_request(:get, "https://api.github.com/search/repositories?order=desc&page=15&q=ruby&sort=best%20match").to_timeout

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
      expect(response.body).to include('ruby/ruby')
      expect(response.body).to include('The Ruby Programming Language [mirror]')
    end
  end
  
  context 'GET search repositories with pages' do
    it 'should find repositories at 25 page' do 
      get '/', :params => {search: 'ruby', page: 25}
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
      expect(response.body).to include('bitmakerlabs/learn_ruby')
      expect(response.body).to include('Ethereum library for the Ruby language')
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
  context "side API" do

    it '500 error' do
      get '/', :params => {search: 'ruby', page: 20}
      expect(response.body).to include('500 Internal Server Error')
    end

    it 'time out error' do
      get '/', :params => {search: 'ruby', page: 15}

      expect(response.body).to include('Timed out connecting to server')
    end
  end
    
end
