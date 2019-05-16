require 'http'
require 'json'
# require_relative '/config/apis.yml'

# collections
# [ "carts" , "events" , "notifications" , "objectlabs-system" , "objectlabs-system.admin.collections" , "posts" , "products" , "races" , "registrations" , "sessions" , "system.indexes" , "users" ]

def get_datas collection, querry
  unparsed_page = HTTP.get("https://api.mlab.com/api/1/databases/#{ENV["MLAB_DB"]}/collections/#{collection}?apiKey=#{ENV["MLAB_API_KEY"]}&q=#{querry}")

  parsed_datas = JSON.parse(unparsed_page)

end

module Datas


  def Datas.get_carts_datas event_id
    collection = "carts"

    querry = "%7B\"products.event\"%3A%7B\"%24oid\"%3A\"#{event_id}\"%7D%7D"

    datas = get_datas(collection, querry)

  end

end

