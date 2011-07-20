module Rbase
  class Table
    def initialize(client, table_name)
      @client = client
      @table_name = table_name.to_s
    end

    def find(row)
      @client.getRow(@table_name,row).map { |row| row_to_hash(row) }
    end

    def first(row)
      find(row).first
    end
    alias_method :[], :first

    def insert(row, hash)
      hash.each do |family,value|
        mutations = value.map do |column,val|
          Apache::Hadoop::Hbase::Thrift::Mutation.new(:column => "#{family}:#{column}", :value => val)
        end
        @client.mutateRow(@table_name,row,mutations)
      end
    end
    alias_method :[]=, :insert

    def multi_insert(rows)
      row_mutations = rows.map do |row, hash|
        hash.map do |family,value|
          mutations = value.map do |column,val|
            Apache::Hadoop::Hbase::Thrift::Mutation.new(:column => "#{family}:#{column}", :value => val)
          end
          Apache::Hadoop::Hbase::Thrift::BatchMutation.new(:row => row, :mutations => mutations)
        end
      end
      @client.mutateRows(@table_name, row_mutations.flatten)
    end

    def each_batch(batch_size=100, columns=[])
      columns = [columns] unless columns.is_a?(Array)
      scanner_id = @client.scannerOpen(@table_name, '', columns)
      loop do
        results = @client.scannerGetList(scanner_id, batch_size)
        break if results.length == 0
        yield results.map {|r| row_to_hash(r) }
      end
      @client.scannerClose(scanner_id)
    end

    def each(batch_size=100, columns=[])
      each_batch(batch_size, columns) do |results|
        results.each do |result|
          yield(result)
        end
      end
    end

    def set_auto_flush(enabled)
      @client.setAutoFlush(@table_name, enabled)
    end
    
    def increment(row, family, column, value)
      @client.atomicIncrement(@table_name, row, "#{family}:#{column}", value)
    end

    private

    def row_to_hash(row)
      ret_val = {}
      row.columns.each do |column,val|
        family, key = *column.split(":")
        ret_val[family] ||= {}
        ret_val[family][key] = val.value
      end
      ret_val
    end
  end
end