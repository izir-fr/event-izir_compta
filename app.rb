require 'dotenv/load'

require './app/controllers/inscriptions'
require_relative './app/routes/api_mlab'

puts "Quel ets l'ID de l'événement ?"

event = gets.chomp.to_s

carts = Datas.get_carts_datas(event)

paiements = Inscriptions.new
paiements.Paiement_check(carts, event)

puts "#{paiements.facturation.count} paiements pour #{paiements.participants} inscriptions et #{paiements.options} options avec CB pour #{paiements.total}"

paiements.csv_export(event)