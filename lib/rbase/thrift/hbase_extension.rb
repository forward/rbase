module Apache
  module Hadoop
    module Hbase
      module Thrift
        module Hbase
          class Client
            def setAutoFlush(tableName, enabled)
              send_setAutoFlush(tableName, enabled)
              return recv_setAutoFlush()
            end

            def send_setAutoFlush(tableName, enabled)
              send_message('setAutoFlush', SetAutoFlush_args, :tableName => tableName, :enabled => enabled)
            end

            def recv_setAutoFlush()
              receive_message(SetAutoFlush_result)
            end
          end

          class SetAutoFlush_args
            include ::Thrift::Struct, ::Thrift::Struct_Union
            TABLENAME = 1
            ENABLED = 2

            FIELDS = {
              TABLENAME => {:type => ::Thrift::Types::STRING, :name => 'tableName', :binary => true},
              ENABLED => {:type => ::Thrift::Types::BOOL, :name => 'enabled'}
            }

            def struct_fields; FIELDS; end

            def validate
            end

            ::Thrift::Struct.generate_accessors self
          end

          class SetAutoFlush_result
            include ::Thrift::Struct, ::Thrift::Struct_Union

            FIELDS = {}

            def struct_fields; FIELDS; end

            def validate
            end

            ::Thrift::Struct.generate_accessors self
          end
          
          class Processor
            def process_setAutoFlush(seqid, iprot, oprot)
              args = read_args(iprot, SetAutoFlush_args)
              result = SetAutoFlush_result.new()
              begin
                result.success = @handler.setAutoFlush()
              rescue Apache::Hadoop::Hbase::Thrift::IOError => io
                result.io = io
              end
              write_result(result, oprot, 'setAutoFlush', seqid)
            end
            
          end
        end
      end
    end
  end
end
