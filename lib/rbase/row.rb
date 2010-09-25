module Rbase
  class Row
    def initialize(client,table_name,row)
      @client = client
      @table_name = table_name.to_s
      @row = row.to_s
    end
    
    def <<(hash)
      hash.each do |family,value|
        mutations = value.map do |column,val|
          Apache::Hadoop::Hbase::Thrift::Mutation.new(:column => "#{family}:#{column}", :value => val)
        end
        @client.mutateRow(@table_name,@row,mutations)
      end
    end
    
    def value
      @client.getRow(@table_name,@row).map do |row|
        ret_val = {}
        row.columns.each do |column,val|
          family, key = *column.split(":")
          ret_val[family] ||= {}
          ret_val[family][key] = val.value
        end
        ret_val
      end
    end
    
    def to_s
      value.to_s
    end
    
    def inspect
      value.inspect
    end
  end
end