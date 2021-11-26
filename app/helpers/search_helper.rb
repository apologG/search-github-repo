module SearchHelper
  class GithubApi
    def initialize(params, page)
      @page = page
      @params = params
      @uri = 'https://api.github.com/search/repositories'
    end

    def find_repositories
      RestClient.get @uri, {params: {q: @params, sort:'stars', order:'desc', page: @page}}
    end
  end
end
