module Rbase
  class Client
    def self.connect(server, port=9090, &blk)
      client = Client.new(server, port)
      yield client if block_given?
    end
    
    def initialize(server, port=9090)
      socket = Thrift::Socket.new(server, port.to_s)
      transport = Thrift::BufferedTransport.new(socket)
      transport.open

      protocol = Thrift::BinaryProtocol.new(transport)
      @tables = {}
      @client = Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(protocol)
    end
    
    def table_names
      @client.getTableNames
    end
    
    def table_exists?(table_name)
      table_names.include?(table_name)
    end
    
    def create_table(table_name, *column_family_names)
      column_families = column_family_names.map do |family_name|
        Apache::Hadoop::Hbase::Thrift::ColumnDescriptor.new(:name => family_name)
      end
      @client.createTable(table_name, column_families)
    end
    
    def create_table!(table_name, *column_family_names)
      if table_exists?(table_name)
        delete_table(table_name)
      end
      create_table(table_name, *column_family_names)
    end
    
    def delete_table(table_name)
      @client.disableTable(table_name)
      @client.deleteTable(table_name)
      @tables.delete(table_name)
    end
    
    def [](table_name)
      @tables[table_name] ||= Rbase::Table.new(@client, table_name) if table_exists?(table_name)
      @tables[table_name]
    end
  end
end