require 'sinatra'
require 'csv'

set :bind, '0.0.0.0'



get '/articles/new' do
  erb :article_news
end

post '/articles/new' do
  @all_urls = []
  CSV.foreach("articles.csv", headers: true) do |row|
    @all_urls << row["url"]
  end

  @title = params[:title]
  @url = params[:url]
  @description = params[:description]

  @error = ''
  @success = nil

  @control = true
  if @title == ''
    @error += "No title!\n"
    @control = false
  end


  if @url == ''
    @error += "No URL!\n\n"
    @control = false
  elsif !@url.include?("http")
    @error += "Invalid URL!\n\n"
    @control = false
  elsif @all_urls.include?(@url)
    @error += "Article already exists\n\n"
    @control = false
  end

  if @description == ''
    @error += "No description!\n\n"
    @control = false
  elsif @description.size < 20
    @error += "Description is too short!\n\n"
    @control = false
  end

  if @control
    csv_row = @title,@url,@description
    add_to_csv("articles.csv", csv_row)
    @success = "Subitted"
    redirect '/articles/new'
  end


  #redirect '/articles/new'
  erb :article_news
end

get '/articles' do
  @articles = CSV.read("articles.csv", headers: true)
  erb :articles
end



def add_to_csv(file_name, input)
  CSV.open(file_name, "a") do |file|
    file.puts(input)
  end
end
