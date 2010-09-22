require File.join(File.dirname(__FILE__), *%w[.. lib rbhbase])

socket = Thrift::Socket.new("hbase-master.hadoop.forward.co.uk", "9090")
transport = Thrift::BufferedTransport.new(socket)
transport.open

protocol = Thrift::BinaryProtocol.new(transport)
client = Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(protocol)

## Get Table meta data
p client.getTableNames