module Rbase
  class Client
    attr_reader :client
    
    def initialize(server,port=9090)
      socket = Thrift::Socket.new(server, port.to_s)
      transport = Thrift::BufferedTransport.new(socket)
      transport.open

      protocol = Thrift::BinaryProtocol.new(transport)
      @tables = {}
      @client = Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(protocol)
    end
    
    def table_names
      client.getTableNames
    end
    
    def create_table(table_name, *column_family_names)
      column_families = column_family_names.map do |family_name|
        Apache::Hadoop::Hbase::Thrift::ColumnDescriptor.new(:name => family_name)
      end
      client.createTable(table_name, column_families)
    end
    
    def delete_table(table_name)
      @client.disableTable(table_name)
      @client.deleteTable(table_name)
    end
    
    def [](table_name)
      table_name = table_name.to_sym
      @tables[table_name] ||= Rbase::Table.new(client, table_name)
      @tables[table_name]
    end
  end
end