class SearchController < ApplicationController

  def index
  begin 
    @repositories = Github::GithubApi.call(params[:search], params[:page])
  rescue RestClient::RequestTimeout => e
    flash[:alert] = e.message
  rescue RestClient::ExceptionWithResponse => e 
    flash[:alert] = e.message
  rescue StandardError => e
    flash[:alert] = e.message
  end
    
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
