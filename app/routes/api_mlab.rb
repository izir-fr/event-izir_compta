require 'http'
require 'json'
# require_relative '/config/apis.yml'

# collections
# [ "carts" , "events" , "notifications" , "objectlabs-system" , "objectlabs-system.admin.collections" , "posts" , "products" , "races" , "registrations" , "sessions" , "system.indexes" , "users" ]

def get_datas collection, querry
  api = "https://api.mlab.com/api/1/databases/#{ENV["MLAB_DB"]}/collections/"
  if querry
    url = "#{api}#{collection}?apiKey=#{ENV["MLAB_API_KEY"]}&q=#{querry}"
  else
    url = "#{api}#{collection}?apiKey=#{ENV["MLAB_API_KEY"]}"
  end
  
  unparsed_page = HTTP.get(url)

  parsed_datas = JSON.parse(unparsed_page)

end

module Datas

  def Datas.get_carts_datas event_id
    querry = "%7B\"products.event\"%3A%7B\"%24oid\"%3A\"#{event_id}\"%7D%7D"
    
    collection = "carts"

    datas = get_datas(collection, querry)

  end

  def Datas.get_user user_id
    querry = false

    collection = "users/#{user_id}"

    datas = get_datas(collection, querry)

  end

end

