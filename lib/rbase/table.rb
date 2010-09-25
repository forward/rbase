module Rbase
  class Table
    def initialize(client, table_name)
      @client = client
      @table_name = table_name.to_s
    end
    
    def [](row)
      Rbase::Row.new(@client,@table_name,row)
    end
    
    def delete
      @client.disableTable(@table_name)
      @client.deleteTable(@table_name)
    end
  end
end