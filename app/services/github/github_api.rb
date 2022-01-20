module Github
  class GithubApi
    def initialize(search_line, page)
      @page = page
      @search_line = search_line
      @uri = 'https://api.github.com/search/repositories'
    end

    def find_repositories
      RestClient.get @uri, {params: {q: @search_line, sort: 'best match',  order:'desc', page: @page}}
    end
  end
end
