require 'logger'

class SimplerLogger

  def initialize(app, log_path)
    @app = app
    @logger = Logger.new(Simpler.root.join(log_path))
  end

  def call(env)
    @env = env
    @response = @app.call(env)
    @logger.info(message)
    @response
  end

  private

  def message
    "\nRequest: #{@env["REQUEST_METHOD"]} #{@env["REQUEST_URI"]}\n" \
    "Handler: #{@env["simpler.controller"].class}##{@env["simpler.action"]}\n" \
    "Parameters: #{@env["simpler.params"]}\n" \
    "Response: #{@response[0]} [#{@response[1]["Content-Type"]}] #{@env["simpler.path"]}\n"
  end
end
