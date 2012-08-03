# encoding: utf-8
require 'sinatra'
require 'json'
require 'haml'
require 'net/http'
require 'uri'
require 'open-uri'
require 'oauth2'
require 'less'
require 'rest-client'

class String
  def scan2(regexp)
    names = regexp.names
    if (names.count>0)
      scan(regexp).collect do |match|
        Hash[names.zip(match)]
      end
    else
      scan regexp
    end  
  end
end

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
  
  #Less.paths << settings.views

end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def nl2br(s)
    s.gsub(/\r?\n/, "<br />") 
  end
end

get '/' do		
	haml :index, :locals => {}
end

get '/css/:style.css' do
	less params[:style].to_sym, :paths => ["public/css"], :layout => false
end

get '/do' do
	"Welcome to Sibex. Regulare Expression experimental"

r = /<([a-zA-Z0-9]*)>/
s = "This is a <psa><strong>test</strong> <a title=\"sasa\">test string<p>"
c = s.scan r
 "result =" << c.inspect
end


post '/do3' do
  result = Array.new
  result << params[:testString]
  result.inspect
end

post '/evaluate' do
=begin
   TEST 1:
   <i>(?<num>[0-9]+)</i><p>(?<manga>[^<]+)<\/p>
   
    sasas<i>1</i><p>Breakshot</p>
    l sa sa<p>kazu</p> as sa

    sasas<i>2</i><p>Breakshot</p>
    l sa sa<p>kazu</p> as sa

    TEST 2:
    \(([a-zA-Z\s_-]+)\)

    huhgygu(sa) sas(num)

    TEST 3
    \((?<name>[a-zA-Z\s_-]+)\)
    huh(tieu phug) huh(sa man)

    TEST 4
    \((?<name>[a-zA-Z\s_-]+)\)[a-zA-Z\s]+(?<age>[0-9]+)
    huh(tieu phug) hu 15 h(sa man)a tuoi 29
=end

  result = Array.new
  result << {'myNumber' => params[:myNumber]}
  r = params[:r]
  testString = params[:s]
  if (r.length==0 || testString.count==0) 
    halt 500, 'Invalid Data!'
  end
  r = Regexp.new(r, true);
  testString.collect do |s|
    c = s.scan2 r
    s.gsub! r do |m|
      "{{mark}#{m}{mark}}"
    end 
    result << [s, c]
  end  
  
  result = result.map do |m|
    m[0] = h m[0]
    m[0].gsub!("{{mark}", '<span class="label label-success">')
    m[0].gsub!("{mark}}", "</span>")
    nl2br(m[0])
    m
  end

  content_type :json
  result.to_json
end

post '/do2' do
  result = Array.new
  parsed_string = Array.new
  result << {'myNumber' => params[:myNumber]}
  r = /(?<month>\d{1,2})\/(?<day>\d{1,2})\/(?<year>\d{4})/i; 
  #r = /(\d{1,2})\/(\d{1,2})\/(\d{4})/i
  s = "Today's date is: 7/15/2012. Obon Festival is on 10/10/2012"
  c = s.scan2 r

  resule_element = Array.new
  s.gsub! r do |m|
    "{{mark}#{m}{mark}}"
  end 
  result << [s, c]

  r = /<([a-zA-Z0-9]*)>/
  s = "This is a <psa><strong>test</strong> <a title=\"sasa\">test string<p>"
  c = s.scan2 r

  s.gsub! r do |m|
    "{{mark}#{m}{mark}}"
  end 
  result << [s, c]


  r = /<tr>([0-9]+)<td>(?<manga>[^<]+)<\/td><\/tr>/im;
  s = "Today's date is: 7/15/2012.
      <tr>1<td>Breakshot</td></tr>
help di hà hâ hố hê ma h
  lop 
    <tr>2<td>Bartender</td></tr>"

  c = s.scan2 r

  s.gsub! r do |m|
     "{{mark}#{m}{mark}}"
  end 
  result << [s, c]

  result = result.map do |m|
    m[0] = h m[0]
    m[0].gsub!("{{mark}", '<span class="label label-success">')
    m[0].gsub!("{mark}}", "</span>")
    nl2br(m[0])
    m
  end

 # parsed_string.inspect
  content_type :json
  result.to_json
  #{}"#{parsed_string.join('<br />')}<br />#{result.join('<br />')}"
end

get '/about' do
  "@kureikain"
end

get '/help' do
  "@Help Page"
end

def client
  OAuth2::Client.new(settings.CLIENT_ID, settings.CLIENT_SECRET,
                     :ssl => {:ca_file => '/etc/ssl/ca-bundle.pem'},
                     :site => 'https://api.github.com',
                     :authorize_url => 'https://github.com/login/oauth/authorize',
                     :token_url => 'https://github.com/login/oauth/access_token')
end

get '/mine' do
  url = URI.parse('https://api.github.com/users/kureikain/gists')
  data = RestClient.get 'https://api.github.com/users/kureikain/gists'
  #resp, data = Net::HTTP.get_response(url)

  "Response is #{data.inspect}"
end  

get '/delete/:gist_id' do
  url = "https://api.github.com/gists/:#{params[:gist_id]}"
  resp = RestClient.delete url
  resp.inspect
end 

get '/create' do
  url = 'https://api.github.com/gists?access_token=2ed1d303c6d9db90e9be50b706983356fe5e7227'
  post_args = {
    :description  => "Second Test Sigular",
    :public       => true,
    :files        => {
      "sigular.json" => {
          :content => "{name: test, regex: sa}"
      },
      "second.txt" => {
        :content => "Ngay hom qua o lai trong ruon "
      
      }
    }
  }
  resp = RestClient.post url, post_args.to_json, :content_type => :json, :accept => :json
  resp.inspect
end  

#
# 2ed1d303c6d9db90e9be50b706983356fe5e7227
#Your OAuth access token: 2ed1d303c6d9db90e9be50b706983356fe5e7227
#Your extended profile data: {"html_url"=>"https://github.com/kureikain", "type"=>"User", "location"=>"San Jose, California, USA", "company"=>"Axcoto", "gravatar_id"=>"659d0c8387cefd176347beef316688cd", "public_repos"=>42, "login"=>"kureikain", "following"=>99, "blog"=>"http://axcoto.com/", "public_gists"=>31, "hireable"=>true, "followers"=>10, "name"=>"Vinh Quốc Nguyễn", "avatar_url"=>"https://secure.gravatar.com/avatar/659d0c8387cefd176347beef316688cd?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png", "email"=>"kureikain@gmail.com", "bio"=>"Web developer who loves to work with both of back-end, front-end stuff and even sys admin too. Thing changed so much since the first day I touch to that kind of machine.\r\n", "url"=>"https://api.github.com/users/kureikain", "id"=>49754, "created_at"=>"2009-01-27T21:11:00Z"}

get '/session/s' do
  session[:user] = 'kureikain'
end

get '/session' do
  "session is #{session.inspect}"
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
    session[:user] = {
      :login
    }
    [:login] = user[:login];
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