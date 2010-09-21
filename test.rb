require File.join(File.dirname(__FILE__), 'rbhbase')

transport = Thrift::BufferedTransport.new(Thrift::Socket.new("hbase-master.hadoop.forward.co.uk", "9090"))
transport.open

client = Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(Thrift::BinaryProtocol.new(transport))

## Get Table meta data
p client.getTableNames