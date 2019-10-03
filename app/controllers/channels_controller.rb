class ChannelsController < ApplicationController
    before_action :authorize_request, except:[:getChannelOfUser, :getChannelByToken]
    before_action :findUser, only:[:getChannelOfUser]
    before_action :set_post_user, only:[:editChannel, :deleteChannel]
    before_action :findChannel, only:[:getChannelByToken]




    def createChannel
        if @current_user.suspended==true
            render :json=>{code:"01", message:"you cannot create a channel, your account has been suspended"}, status: :unauthorized
        else
            @channel = Channel.new(create_params)
            @channel.user_id = @current_user.id
            if @channel.save
                render :json=>{code:"00", message:"channel created successfully", channel:@channel}, status: :ok
            else
                render :json=>{code:"01", message:"error creating channel"}, status: :unprocessable_entity
            end
        end
    end

    def getYourChannel
        if @current_user.suspended==true
            render :json=>{code:"01", message:"your account has been suspended"}, status: :unauthorized
        else
           @channel= Channel.paginate(page: params[:page], per_page: params[:per_page]).where(user_id: @current_user.id)
           render :json=>{code:"00", message:@channel}, status: :ok
        end
        #using include would not allow pagination
        #render :json=>{code:"00", message:@current_user, pics:pics}.to_json(:include=>{:channels=>{}}), status: :ok
    end

    def getChannelOfUser
        
        @channel= Channel.paginate(page: params[:page], per_page: params[:per_page]).where(user_id: @user.id)
        render :json=>{code:"00", message:@channel}, status: :ok

    end

    def editChannel
        if @current_user.suspended==false
            if @post.update(edit_params)
                render :json=>{code:"00", message:"channel updated successfully"}, status: :ok
            else
                render :json=>{code:"01", message:"error updating channel"}, status: :unprocessable_entity
            end
        else
            render :json=>{code:"01", message:"your account has been suspended"}, status: :unauthorized
        end
        
    end

    def getChannelByToken
        render :json=>{code:"00", message:@channel}, status: :ok
    end

    def deleteChannel
        #todo: delete all the content in the channel when you create content model
        if @current_user.suspended==false
            @post.destroy
            render :json=>{code:"00", message:"channel deleted successfully"}, status: :ok
        else
            render :json=>{code:"01", message:"your account has been suspended"}, status: :unauthorized
        end
    end

    def getAllChannels
            @channels= Channel.paginate(page: params[:page], per_page: params[:per_page]).order("created_at DESC")
            @total=@channels.total_entries
            render :json=>{code:"00", message:@channels, total:@total}, status: :ok
    end

    def searchChannel
        @channels = Channel.paginate(page: params[:page], per_page: params[:per_page]).where("name LIKE ? OR description LIKE ?", "%#{params[:any]}%", "%#{params[:any]}%").order("created_at DESC")
        @total=@channels.total_entries
        render :json=>{code:"00", message:@channels, total:@total}

    end

    

    private

    def create_params
        params.permit(
           :name, :description, :content
          )
    end

    def edit_params
        params.permit(
           :name, :description
          )
    end

    def findUser
        @user = User.find_by_token(params[:token])
      end

      def findChannel
          @channel=Channel.find_by_token_channel(params[:token_channel])
      end

      def set_post_user
        @post = @current_user.channels.find_by!(id: params[:id]) if @current_user
      end
end
