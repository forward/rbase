module Rbase
  class Table
    def initialize(client, table_name)
      @client = client
      @table_name = table_name.to_s
    end
    
    def find(row)
      @client.getRow(@table_name,row).map do |row|
        ret_val = {}
        row.columns.each do |column,val|
          family, key = *column.split(":")
          ret_val[family] ||= {}
          ret_val[family][key] = val.value
        end
        ret_val
      end
    end
    
    def insert(row, hash)
      hash.each do |family,value|
        mutations = value.map do |column,val|
          Apache::Hadoop::Hbase::Thrift::Mutation.new(:column => "#{family}:#{column}", :value => val)
        end
        @client.mutateRow(@table_name,row,mutations)
      end
    end
  end
end