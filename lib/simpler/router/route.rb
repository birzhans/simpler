module Simpler
  class Router
    class Route

      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
      end

      def match?(env, method, path)
        @env = env
        @method == method && path_match?(path)
      end

      def path_match?(request_path)
        return true if request_path == @path

        request_path_list = get_parts(request_path)
        path_list = get_parts(@path)

        return false if request_path_list.size != path_list.size

        path_list.each_with_index do |k, i|
          if k[0] == ':'
            set_param(k, request_path_list[i])
          else
            return false unless k == request_path_list[i]
          end
        end
      end

      def get_parts(path)
        if path.empty?
          []
        else
          path.split("/")
        end
      end

      private

      def set_param(k, v)
        @env['simpler.params'] ||= {}
        @env['simpler.params'][k] = v
      end

    end
  end
end
