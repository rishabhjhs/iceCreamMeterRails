module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do

        rescue_from ActiveRecord::RecordNotFound do |e|
          render json: {
              error: e.to_s
          }, status: :not_found
        end
        rescue_from StandardError do |e|
          render json: {
              error: e.to_s
          }, status: :not_found
        end
      end
    end

    private

    def respond(_error, _status, _message)
      json = Helpers::Render.json(_error, _status, _message)
      render json: json, status: _status
    end
  end
end


