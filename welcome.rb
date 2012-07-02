require 'sinatra'
require 'json'
require 'net/http'
require 'uri'
require 'open-uri'

get '/' do
	"Welcome to Sibex. Regulare Expression 
end

get '/about' do
  "@kureikain"
end

get '/help' do
  "@Help Page"
end


get '/api/site' do
	content_type :json
	{:vechai => 'Vechai', :vnsharing => 'VnSharing', :blogtruyen => 'BlogTruyen' }.to_json
end


get '/api/:site/list' do
	content_type :json
	@url = "http://truyen.vnsharing.net/DanhSach";
	url = URI.parse(@url)

        str = ''
        open(url) {|f| #url must specify the protocol
            str += f.read()
        }
        
end

get '/api/:manga/info' do
	@manga = params[:manga]
	@manga
end

get '/api/:site/:manga/chapter' do
	@manga = params[:manga]
	content_type :json
	chapter = Array.new
	chapter[0] = "Chapter 1"	
	chapter[1] = "Chapter 2"	
	chapter[2] = "Chapter 3"	
	chapter[3] = "Chapter 4"
	chapter.to_json
end

get '/api/:site/:manga/:chapter/content' do
	content_type :json
	@manga = params[:manga]
	@chapter = params[:chapter]
	pic = Array.new
	pic[0] = "Asaa asa"
	pic[1] = "Asaa sa asa"
	pic[2] = "Asaa s a asa"
	pic[3] = "As saaa asa"
	pic[4] = "As saaa asa"
	pic[5] = "Asa saa asa"
	pic[6] = "As saaa asa"
	pic[7] = "As sa aa asa"
	pic.to_json
end


