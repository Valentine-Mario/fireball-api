class UserController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request, only: [:getProfile, :addPics, :removePics, 
        :editPassword, :deleteUser]
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
            render :json=>{code:"01", message:"your account has been suspended"}, status: :ok
        else
            pics= rails_blob_url(@current_user.avatar)
            render :json=>{code:"00", message:@current_user, pics:pics}, status: :ok
        end
    end

    def addPics
        if @current_user.suspended==false
            if  @current_user.avatar.attach(params[:avatar])
                render :json=>{code:"00", message:"profile picture uploaded successfully"}, status: :ok
            else
                render :json=>{code:"01", message:"error uploading picture"}, status: :unprocessable_entity
            end
        else
            render :json=>{code:"01", message:"account suspended"}, status: :ok
        end
    end

    def removePics
        if @current_user.suspended==false
            @current_user.avatar.attach(io: File.open(Rails.root.join("app", "assets", "images", "default.png")), filename: 'default.png' , content_type: "image/png")
            render :json=>{code:"00", message:"profile pics removed successfully"}
        else
            render :json=>{code:"01", message:"account suspended"}, status: :ok
        end
    end

    def editPassword 
        if @current_user&.authenticate(params[:old_password])
           
                if user_edit_password['password'].length < 6
                    render :json=>{code:"01", message:"password must be at least 6 characters"}, status: :ok
                else
                    @current_user.update(user_edit_password)
                    render :json=>{code:"00", message:"password updated successfully"}, status: :ok      
                end
            else
                render :json=>{code:"00", message:"authorization failed"}, status: :unauthorized
        end
    end

    def deleteUser
        @current_user.avatar.purge
        if @current_user.destroy
            render :json=>{message:"user deleted successfully"}, status: :ok
        else
            render :json=>{message:"error deleting user"}, status: :unprocessable_entity
        end
    end

private
def user_params
        
    params.permit(
       :name, :email, :password, :password_confirmation, :isAdmin, :suspended
      )
end

def user_edit_password
    params.permit(:password)
end
end
