module ExceptionHandler
    # provides the more graceful `included` method
    extend ActiveSupport::Concern
  
    included do
      rescue_from ActiveRecord::RecordNotFound do |e|
        render :json=>{code:"03", message: e.message },status: :not_found
      end
  
      rescue_from ActiveRecord::RecordInvalid do |e|
        render :json=>{code:"03", message: e.message }
      end
    end
  end