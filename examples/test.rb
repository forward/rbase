require 'rubygems'
require 'rbhive'
require File.join(File.dirname(__FILE__), *%w[.. lib rbase])

table = "lovehoney_keywords"
column_family = "AccountInfo"

client = Rbase::Client.new("hbase-master.hadoop.forward.co.uk")
client.create_table(table, column_family)

RBHive.connect('hive.hadoop.forward.co.uk') {|db| 
  results = db.fetch %[select keyword,campaign,match_type from lovehoney_keywords where dated = '2010-09-21' and client = 'lovehoney']
  results.each do |row|
    client[table][row[0]] << { column_family => {"campaign" => row[1], "match_type" => row[2]} }
  end
}
