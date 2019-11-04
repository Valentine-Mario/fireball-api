class SubscriptionController < ApplicationController
    before_action :authorize_request
    before_action :set_post_user, only:[:deleteSub]

    def addSub
        if @current_user.suspended== false
            @channel=Channel.find_by!(id: params[:id])
            @sub_check= Subscription.where(user_id:@current_user.id , channel_id:@channel.id )
            if @sub_check.length>0
                render :json=>{code:"01", message:"you are already subscribed to this channel"}, status: :ok
            else
                @sub= @channel.subscriptions.create
                @sub.user_id=@current_user.id
                @sub.save
            
                render :json=>{code:"00", message:"subscription to "+@channel.name+" successful"}, status: :ok
            end

        else
            render :json=>{code:"01", message:"your account has been suspended you cannot subscribe to a channel"}
        end
    end

    def deleteSub
        if @current_user.suspended==false
            @subscribe.destroy
            render :json=>{code:"00", message:"unsunscribed successfully"}
        else
            render :json=>{code:"01", message:"your account has been suspended"}
        end
    end

    def viewSub
        @sub=@current_user.subscriptions.paginate(page: params[:page], per_page: params[:per_page])
        @total=@sub.total_entries
        render :json=>{code:"00", message:@sub, total:@total}.to_json(:include=>{:channel=>{}}), status: :ok
    end

    private
    def set_post_user
        @subscribe = @current_user.subscriptions.find_by!(id: params[:id]) if @current_user
      end

end
