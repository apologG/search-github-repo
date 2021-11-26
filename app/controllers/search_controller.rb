class SearchController < ApplicationController

  def index
    @repositories = Search.search(params[:search], params[:page])
    if @repositories.present?
      @selected_page = params[:page]
      @total_pages = pages(@repositories)
    end
  end

  private

  def github_params
    params.require(:search).permit(:search, :page)
  end

  # по каким-то причинам максимальнное количество
  # репозиториев которое можно найти не превышает 1000
  # все что выше 34(per_page: 30) страницы будет выдавать ошибку 422
  def pages(repo)
    total_pages = (repo['total_count'].to_f / 30).ceil
    if total_pages > 35
      return 34
    else
      return total_pages
    end
  end

end
