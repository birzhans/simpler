require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = get_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_headers
      send(action)
      write_response

      @response.finish
    end

    def make_404_response
      set_status 404
      set_header['Content-Type'] = "text/plain"
      make_404_response_body

      @response.finish
    end

    private

    def get_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_headers(*type)
      @response['Content-Type'] = type ? "text/#{type}" : 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def make_404_response_body
      method = @request.env["REQUEST_METHOD"]
      resource = @request.env["REQUEST_PATH"]
      body = "Resource '#{resource}' for #{method} request method was not found."

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params.merge!(@request.env['simpler.params'])
    end

    def render(template)
      if template.instance_of?(Hash)
        type = template.keys[0]
        set_headers(type)

        content = template.values[0]
        @request.env['simpler.template'] = content
      else
        @request.env['simpler.template'] = template
      end
    end

    def set_content_type(rendering_type)
      @response['Content-Type'] = "text/#{rendering_type}"
    end

    def set_status(status_code)
      @response.status = status_code
    end

  end
end
