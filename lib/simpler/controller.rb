require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      
      send(action)
      set_default_headers if @response['Content-Type'].nil?
      set_default_status

      write_response

      @request.env['simpler.response.status'] = @response.status
      @request.env['simpler.response.header'] = @response['Content-Type']

      @response.finish
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def set_default_status
      status 200
    end

    def status(code)
      @response.status = code
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.env['simpler.request.params'].merge!(@request.params)
    end

    def render(template)
      if template.class == String
        @response['Content-Type'] = 'text/html'
      elsif template.class == Hash && template.keys[0] == :plain
        @response['Content-Type'] = 'text/plain'  
      end
      @request.env['simpler.template'] = template
    end

  end
end
