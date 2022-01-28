require 'rails_helper'

RSpec.describe Github::GithubApi do
  
  describe '#call' do
	  before do 
			stub_request(:get, "https://api.github.com/search/repositories?order=desc&page=25&q=ruby&sort=best%20match").to_return(
				status: 200, 
				body: File.read('spec/fixtures/response.json'), 
				headers: {})
			stub_request(:get, "https://api.github.com/search/repositories?order=desc&page=1&q=ruby&sort=best%20match").to_return(
				status: 200, 
				body: File.read('spec/fixtures/response.json'), 
				headers: {})		
		end
	
		it 'should return success request with page 10' do
			response = described_class.call('ruby', 25)

			expect(response['total_count']).to be(365_132)
			expect(response['incomplete_results']).to be_falsey
			expect(response['items'].first['full_name']).to eq ("ua-parser/uap-ruby")
		end

		it 'should return page 1 with params page 35' do 
			response = described_class.call('ruby', 35)

			expect(response['total_count']).to be(365_132)
			expect(response['incomplete_results']).to be_falsey
			expect(response['items'].first['full_name']).to eq ("ruby/ruby")

		end

  end

end
