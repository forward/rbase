require 'rubygems'
require 'rbhive'
require File.join(File.dirname(__FILE__), *%w[.. lib rbase])

client = Rbase::Client.new("hbase-master.hadoop.forward.co.uk")
client.create_table("lovehoney_keywords", "AccountInfo")

RBHive.connect('hive.hadoop.forward.co.uk') {|db| 
  results = db.fetch %[select keyword,campaign,match_type from lovehoney_keywords where dated = '2010-09-21' and client = 'lovehoney']
  results.each do |row|
    keyword, campaign, match_type = *row
    client["lovehoney_keywords"].insert(keyword, "AccountInfo" => {"campaign" => campaign, "match_type" => match_type} )
  end
}

p client["lovehoney_keywords"].find("boomboom")
