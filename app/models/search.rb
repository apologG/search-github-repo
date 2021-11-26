class Search < ApplicationRecord

  def self.search(params, page)
    return unless params && params.strip != ''

    if page && !page.empty? && page.to_i <= 34
      response = SearchHelper::GithubApi.new(params, page.to_i).find_repositories
    else
      response = SearchHelper::GithubApi.new(params, 1).find_repositories
    end

    JSON.parse(response)
  end

end
