require 'sinatra'
require 'json'
require 'haml'
require 'net/http'
require 'uri'
require 'open-uri'


configure do
	set :logging, :true

  # setting one option
  set :option, 'value'

  # setting multiple options
  set :a => 1, :b => 2

  # same as `set :option, true`
  enable :option

  # same as `set :option, false`
  disable :option

  # you can also have dynamic settings with blocks
  set(:css_dir) { File.join(views, 'css') }
end

get '/' do
	haml :index
end

get '/style' do
	less :style
end

get '/do' do
	"Welcome to Sibex. Regulare Expression experimental"

r = /<([a-zA-Z0-9]+)/
s = "This is a <strong>test</strong> test string"
c = s.match r
 "result =" << s.inspect
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


