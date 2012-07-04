require 'sinatra'
require 'json'
require 'haml'
require 'net/http'
require 'uri'
require 'open-uri'
require 'oauth2'

configure do
	set :logging, :true
	set :CLIENT_ID => 'd00b37e0fbf1488e8d49', :CLIENT_SECRET => '971ba392a08327aaa02b598ac71bc9258c1314cd'
 
  # same as `set :option, true`
  enable :option

  # same as `set :option, false`
  disable :option	
	
  # you can also have dynamic settings with blocks
  set(:css_dir) { File.join(views, 'css') }
	enable :sessions  
end

#
#Your OAuth access token: 2ed1d303c6d9db90e9be50b706983356fe5e7227
#Your extended profile data: {"html_url"=>"https://github.com/kureikain", "type"=>"User", "location"=>"San Jose, California, USA", "company"=>"Axcoto", "gravatar_id"=>"659d0c8387cefd176347beef316688cd", "public_repos"=>42, "login"=>"kureikain", "following"=>99, "blog"=>"http://axcoto.com/", "public_gists"=>31, "hireable"=>true, "followers"=>10, "name"=>"Vinh Quốc Nguyễn", "avatar_url"=>"https://secure.gravatar.com/avatar/659d0c8387cefd176347beef316688cd?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png", "email"=>"kureikain@gmail.com", "bio"=>"Web developer who loves to work with both of back-end, front-end stuff and even sys admin too. Thing changed so much since the first day I touch to that kind of machine.\r\n", "url"=>"https://api.github.com/users/kureikain", "id"=>49754, "created_at"=>"2009-01-27T21:11:00Z"}

get '/' do
		
	haml :index, :locals => {}
end

get '/session' do
	"session is #{session.inspect}"
end

def client
  OAuth2::Client.new(settings.CLIENT_ID, settings.CLIENT_SECRET,
                     :ssl => {:ca_file => '/etc/ssl/ca-bundle.pem'},
                     :site => 'https://api.github.com',
                     :authorize_url => 'https://github.com/login/oauth/authorize',
                     :token_url => 'https://github.com/login/oauth/access_token')
end

get '/auth/github' do
  url = client.auth_code.authorize_url(:redirect_uri => redirect_uri, :scope => 'gist')
  puts "Redirecting to URL: #{url.inspect}"
  redirect url
end

get '/auth/github/callback' do
  puts params[:code]
  begin
    access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
    user = JSON.parse(access_token.get('/user').body)
    session[:token] = access_token.token;
    session[:user] = Hash.new(nil);
    session[:user][:login] = user[:login];
    session[:user][:email] = user[:email];
    session[:user][:id] = user[:id];
    
    
    "<p>Your OAuth access token: #{access_token.token}</p><p>Your extended profile data:\n#{user.inspect}</p>"
  rescue OAuth2::Error => e
    %(<p>Outdated ?code=#{params[:code]}:</p><p>#{$!}</p><p><a href="/auth/github">Retry</a></p>)
  end
end

def redirect_uri(path = '/auth/github/callback', query = nil)
  #uri = URI.parse(request.url)
  uri = URI.parse(url(path))
  uri.path = path
  uri.query = query
  uri.to_s
end

get '/style' do
	less :style
end

get '/do' do
	"Welcome to Sibex. Regulare Expression experimental"

r = /<([a-zA-Z0-9]*)>/
s = "This is a <psa><strong>test</strong> <a title=\"sasa\">test string<p>"
c = s.match r
 "result =" << c.inspect
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


