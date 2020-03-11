class Admin::AdminController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authorize_request
    before_action :findUser, except:[:getAllUsers]

    def makeAdmin
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"unauthorised to make user admin"}
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
            render :json=>{code:"01", message:"unauthorised to remove admin"}
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
            render :json=>{code:"01", message:"unauthorised to view list of all users"}
        else
            @users= User.paginate(page: params[:page], per_page: params[:per_page]).order("created_at DESC")
            @total=@users.total_entries
            render :json=>{code:"00", message:@users, total:@total}, status: :ok
        end
    end

    def SearchUser
        if @current_user.isAdmin==true
            @user = User.paginate(page: params[:page], per_page: params[:per_page]).where("lower(name) LIKE ? OR lower(email) LIKE ?", "%#{params[:any].downcase}%", "%#{params[:any].downcase}%").order("created_at DESC")
            @total=@user.total_entries
            render :json=>{code:"00", message:@user, total:@total}, status: :ok
        else
            render :json=>{code:"01", message:"unauthorized to access this route"}
        end
    end

    def suspendUser
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"unauthorised to suspend user"}
        else
            if @user.suspended==true
                render :json=>{code:"01", message:@user.name+" is already suspended"}, status: :ok
            else
                @user.update(suspend)
                render :json=>{code:"00", message:@user.name+" has been suspended successfully"}, status: :ok
            end
        end
    end

    def unsuspendUser
        if @current_user.isAdmin==false
            render :json=>{code:"01", message:"unauthorised to suspend user"}
        else
            if @user.suspended==false
                render :json=>{code:"01", message:@user.name+" is not suspended"}, status: :ok
            else
                @user.update(unsuspend)
                render :json=>{code:"00", message:@user.name+" has been unsuspended successfully"}, status: :ok
            end
        end
    end

    private
    def findUser
        @user= User.find(params[:id])
    end

    def suspend
        defaults={suspended:true}
        params.permit(:suspended).reverse_merge(defaults)
    end

    def unsuspend
        defaults={suspended:false}
        params.permit(:suspended).reverse_merge(defaults)
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
