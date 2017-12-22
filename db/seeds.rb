# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

UserChatType.find_or_create_by(name: 'support_on_general')
UserChatType.find_or_create_by(name: 'request')
UserChatType.find_or_create_by(name: 'offers')
UserChatType.find_or_create_by(name: 'order_level')

# }, {name: 'request'}, {name: 'offers'}, {name: 'order_level'}])


# UserChatType.find_or_create_by([
#   { name: "support_on_general" },
#   { name: "request" },
#   { name: "offers"},
#   {name: "order_level"}
# ])