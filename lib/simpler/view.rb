require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if File.exist?(path)
        template = File.read(path)
        @env["simpler.path"] = "#{@path}.html.erb"
      else
        template = @env["simpler.template"]
      end

      ERB.new(template).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def path
      @path = template || [controller.name, action].join('/')

      Simpler.root.join(VIEW_BASE_PATH, "#{@path}.html.erb")
    end

  end
end
