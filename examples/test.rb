require 'rubygems'
require 'rbhive'
require 'json'
require File.join(File.dirname(__FILE__), *%w[.. lib rbase])

client = Rbase::Client.new("hbase-master.hadoop.forward.co.uk")
# client.create_table("lovehoney_keywords", "AccountInfo")
# 
# RBHive.connect('hive.hadoop.forward.co.uk') {|db| 
#   results = db.fetch %[select account,campaign,ad_group,keyword_id,keyword,match_type,status,first_page_bid,quality_score,distribution,max_cpc,destination_url,ad_group_status,campaign_status,impressions,account_id,campaign_id,adgroup_id,dated,client from ask_all_keywords where dated = '2010-09-21' and client = 'lovehoney']
#   results.each do |row|
#     keyword = row.first
#     client["lovehoney_keywords"].insert(keyword, "AccountInfo" => {"campaign" => campaign, "match_type" => match_type} )
#   end
# }

client['andy_keywords'].multi_insert({
  'toni' => {
    'metadata' => {'language' => 'italian'}
  },
  'andy' => {
    'metadata' => {'language' => 'english'}
  },
})
client['andy_keywords'].insert('abs', {
  'metadata' => {'language' => 'british'}
})

puts client['andy_keywords']['toni'].inspect
puts client['andy_keywords']['andy'].inspect
puts client['andy_keywords']['abs'].inspect

# incrementing
client.create_table!("horaci_test", "metadata")

client['horaci_test'].insert('horaci', {
  'metadata' => {'language' => 'spanish', 'age' => [33].pack("Q").reverse}
})

# Column initialized
new_age = client['horaci_test'].increment('horaci', 'metadata', 'age', 1)

# Column not initialized
wrinkles = client['horaci_test'].increment('horaci', 'metadata', 'wrinkles', 8)

puts "New age: #{new_age}"
puts "Wrinkles: #{wrinkles}"
puts "Row: " + client['horaci_test']['horaci'].inspect
puts "unpacked wrinkles: " + client['horaci_test']['horaci']["metadata"]["wrinkles"].reverse.unpack("Q").first.to_s

# client['andy_keywords'].each do |result|
#   puts result.inspect
# end