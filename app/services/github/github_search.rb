module Github
  class GithubSearch

    def self.search(search_line, page)
      return unless search_line && search_line.strip != ''

      page = 
        if page && page.present? && page.to_i <= 34
          page.to_i
        else
          1
        end
      
      response = Github::GithubApi.new(search_line, page).find_repositories
      JSON.parse(response)
       
    end
  end
end
