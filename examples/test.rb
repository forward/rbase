require File.join(File.dirname(__FILE__), *%w[.. lib rbhbase])

require 'rubygems'
gem('thrift')
require 'rbhive'

# socket = Thrift::Socket.new("hbase-master.hadoop.forward.co.uk", "9090")
# transport = Thrift::BufferedTransport.new(socket)
# transport.open
# 
# protocol = Thrift::BinaryProtocol.new(transport)
# client = Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(protocol)

## Get Table meta data
# p client.getTableNames.inspect
# 
# accountColumn = Apache::Hadoop::Hbase::Thrift::ColumnDescriptor.new(:name => "AccountInfo")
# client.createTable("lovehoney_keywords", [accountColumn])

RBHive.connect('hive.hadoop.forward.co.uk') {|db| 
  results = db.fetch %[SELECT keyword,campaign,match_type from lovehoney_keywords where dated = '2010-09-21' and client = 'lovehoney']
  p results.size
  # results.each do |row|
  #   mutation = Apache::Hadoop::Hbase::Thrift::Mutation.new(:column => "AccountInfo:Campaign", :value => row[1])
  #   client.mutateRowTs("lovehoney_keywords",row[0], [mutation])
  # 
  #   mutation = Apache::Hadoop::Hbase::Thrift::Mutation.new(:column => "AccountInfo:MatchType", :value => row[2])
  #   client.mutateRowTs("lovehoney_keywords",row[0], [mutation])
  # end
}

# puts client.getRow("toni2","rowId2").first.columns.inspect
# client.disableTable("toni")
# client.deleteTable("toni")
