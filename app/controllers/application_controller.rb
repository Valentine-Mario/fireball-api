class ApplicationController < ActionController::API
    include ActionController::MimeResponds
    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          @current_user = User.find(@decoded[:user_id])
        rescue ActiveRecord::RecordNotFound => e
          render json: {code:"02", errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: {code:"02", errors: e.message }, status: :unauthorized
        end
      end
    
      include ExceptionHandler
end
