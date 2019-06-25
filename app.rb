require 'dotenv/load'

require './app/models/folders.rb'
require './app/modules/dataset.rb'

puts "Quel est l'ID de l'événement ?"

event_id = gets.chomp.to_s

carts_api_datas = Dataset.get_carts(event_id)

folders = Folders.new

folders.paiement_check(carts_api_datas, event_id)

puts "#{folders.facturation.count} paiements pour #{folders.participants} inscriptions et #{folders.options} options avec CB pour #{folders.total}"

puts "voici les dossiers en litige:"

puts folders.refounded.inspect

folders.export_in_csv(event_id)