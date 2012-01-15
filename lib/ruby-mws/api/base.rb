# This class serves as a parent class to the API classes.
# It shares connection handling, query string building, ?? among the models.

module MWS
  module API

    class Base
      include HTTParty
      # debug_output $stderr  # only in development
      format :xml
      headers "User-Agent"   => "ruby-mws/#{MWS::VERSION} (Language=Ruby/1.9.3-p0)"
      headers "Content-Type" => "text/xml"

      attr_accessor :response

      def initialize(connection)
        @connection = connection
        @saved_options = {}
        self.class.base_uri "https://#{connection.host}"
      end

      def self.def_request(requests, *options)
        [requests].flatten.each do |name|
          # class variable = a way to store options splat to pass into pseudomethod
          self.class_variable_set("@@#{name}_options", options.first)
          self.class_eval %Q{
            def #{name}(params={})
              send_request(:#{name}, params, @@#{name}_options)
            end
          }
        end
      end

      def self.add_list(requests, param, label)
        [requests].flatten.each do |name|
          self.class_variable_set("@@#{name}_options", options.first)
        end
      end

      def send_request(name, params, options)
        # prepare all required params...
        params = [params, options, @connection.to_hash].inject :merge
        
        # default/common params
        params[:action]            ||= name.to_s.camelize
        params[:signature_method]  ||= 'HmacSHA256'
        params[:signature_version] ||= '2'
        params[:timestamp]         ||= Time.now.iso8601
        params[:version]           ||= '2009-01-01'

        params[:lists] ||= {}
        params[:lists][:marketplace_id] = "MarketplaceId.Id"

        query = Query.new params
        @response = Response.new self.class.send(params[:verb], query.request_uri)
        # params[:return] ? params[:return].call(@response) : @response
        begin
          @response.send("#{name}_response").send("#{name}_result")
        rescue NoMethodError
          @response
        end
      end

      def inspect
        "#<#{self.class.to_s}:#{object_id}>"
      end

    end

  end
end