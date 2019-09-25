class AdminController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request, except: []
    before_action :findUser, only:[:makeAdmin, :removeAdmin]

    def makeAdmin
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"unauthorised to make user admin"}, status: :unauthorised
        else
            if @user.isAdmin==true
                render :json=>{code:"00", message:@user.name+" is already an admin"}, status: :ok
            else
                @user.update(setAdmin)
                render :json=>{code:"00", message:@user.name+" is now an admin"}
            end
        end
    end

    def removeAdmin
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"unauthorised to remove admin"}, status: :unauthorised
        else
            if @user.isAdmin==false
                render :json=>{code:"00", message:@user.name+" is not an admin"}, status: :ok
            else
                @user.update(unsetAdmin)
                render :json=>{code:"00", message:@user.name+" is no longer an admin"}, status: :ok
            end
        end
    end

    def getAllUsers
        if @current_user.isAdmin==false
            render :json=>{code:"00", message:"unauthorised to view list of all users"}, status: :unauthorised
        else
            @users= User.paginate(page: params[:page], per_page: params[:per_page]).order("created_at DESC")
            @total=@users.total_entries
            render :json=>{code:"00", message:@users, total:@total}, status: :ok
        end
    end

    private
    def findUser
        @user= User.find(params[:id])
    end

    def setAdmin
        defaults = { isAdmin: true }
        params.permit(:isAdmin).reverse_merge(defaults)
    end

    def unsetAdmin
        defaults={isAdmin:false}
        params.permit(:isAdmin).reverse_merge(defaults)
    end
end
