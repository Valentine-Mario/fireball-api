class UserController < ApplicationController
    before_action :authorize_request, only: [:getProfile]
    def createUser
        @new_user=User.new(user_params)
        if @new_user.save
            
            token = JsonWebToken.encode(user_id: @new_user.id)
            render :json=>{code:"00", message:"account created successfully", token:token}, status: :ok
        else
            render :json=>{code:"01", message:@new_user.errors}, status: :unprocessable_entity
        end
    end

    def getProfile
        if @current_user.suspended==true
            render :json=>{code:"01", message:"your account has been suspended"}
        else
            render :json=>{code:"00", message:@current_user}, status: :ok
        end
    end

private
def user_params
        
    params.permit(
       :name, :email, :password, :password_confirmation, :isAdmin, :suspended
      )
end
end
