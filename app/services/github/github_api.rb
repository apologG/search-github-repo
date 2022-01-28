module Github
  class GithubApi < ApplicationService

    def call
      search
    end

    private

    def initialize(search_line, page)
      @page = page
      @search_line = search_line
      @uri = 'https://api.github.com/search/repositories'
    end
    
    def search
      return unless @search_line && @search_line.strip != ''

      @page = 
        if @page && @page.present? && @page.to_i <= 34
          @page.to_i
        else
          1
        end
           
        response = find_repositories
        JSON.parse(response)

    end

    def find_repositories
      begin
        RestClient.get @uri, {params: {q: @search_line, sort: 'best match',  order:'desc', page: @page}}
      rescue RestClient::RequestTimeout  => e
        raise e
      rescue RestClient::ExceptionWithResponse => e 
        raise e
      rescue StandardError => e
        raise e
      end
    end
  
  end
end
