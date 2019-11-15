class ChannelsController < ApplicationController
    include Rails.application.routes.url_helpers

    before_action :authorize_request, except:[:getChannelOfUser, :getChannelByToken, :getAllChannels, 
        :getVideoChannel, :getPodcastChannel, :searchChannel]
    before_action :findUser, only:[:getChannelOfUser]
    before_action :set_post_user, only:[:editChannel, :deleteChannel,
         :getSubscribersToYourChannel, :updateChannelImage]
    before_action :findChannel, only:[:getChannelByToken, :checkSubscription]




    def createChannel
        if @current_user.suspended==true
            render :json=>{code:"01", message:"you cannot create a channel, your account has been suspended"}
        else
            @channel = Channel.new(create_params)
            @channel.user_id = @current_user.id
            if @channel.save
                render :json=>{code:"00", message:"channel created successfully", channel:@channel}, status: :ok
            else
                render :json=>{code:"01", message:"error creating channel"}
            end
        end
    end



    def getYourChannel
        if @current_user.suspended==true
            render :json=>{code:"01", message:"your account has been suspended"}
        else
           @channel= Channel.paginate(page: params[:page], per_page: params[:per_page]).where(user_id: @current_user.id).order("created_at DESC")
           total=@channel.total_entries
           arr=[]
            for i in @channel do
                pics= rails_blob_url(i.image)
                arr.push({images:pics, content:i})   
            end
           render :json=>{code:"00", message:arr, total:total}, status: :ok
        end
    end



    def getChannelOfUser
        
        @channel= Channel.paginate(page: params[:page], per_page: params[:per_page]).where(user_id: @user.id).order("created_at DESC")
        total=@channel.total_entries
        arr=[]
            for i in @channel do
                pics= rails_blob_url(i.image)
                arr.push({images:pics, content:i})   
            end
        render :json=>{code:"00", message:arr, total:total}, status: :ok

    end



    def editChannel
        if @current_user.suspended==false
            if @post.update(edit_params)
                render :json=>{code:"00", message:"channel updated successfully"}, status: :ok
            else
                render :json=>{code:"01", message:"error updating channel"}
            end
        else
            render :json=>{code:"01", message:"your account has been suspended"}
        end
        
    end



    def getChannelByToken
        if @channel.content==1
            render :json=>{code:"00", channel_pics:rails_blob_url(@channel.image) , message:@channel, subscribers:@channel.subscriptions.length}.to_json(:include=>[:podcasts, :user]), status: :ok

        else
            render :json=>{code:"00", channel_pics:rails_blob_url(@channel.image) , message:@channel, subscribers:@channel.subscriptions.length}.to_json(:include=>[:user, :videos]), status: :ok

        end
    end



    def deleteChannel
        #todo: delete all the content in the channel when you create content model
        if @current_user.suspended==false
            if @post.content==1
                DeletepodcastchannelJob.perform_later(@post)
            elsif @post.content==2
                DeletevideochannelJob.perform_later(@post)
            end
            
            render :json=>{code:"00", message:"channel deletion processing"}, status: :ok
        else
            render :json=>{code:"01", message:"your account has been suspended"}
        end
    end



    def getAllChannels
            @channel= Channel.paginate(page: params[:page], per_page: params[:per_page]).order("created_at DESC")
            @total=@channel.total_entries
            arr=[]
            for i in @channel do
                @user_details=User.find(i.user_id)
                pics= rails_blob_url(i.image)
                arr.push({images:pics, content:i, user:@user_details})   
            end
            render :json=>{code:"00", message:arr, total:@total}, status: :ok
    end



    def searchChannel
        @channels = Channel.paginate(page: params[:page], per_page: params[:per_page]).where("name LIKE ? OR description LIKE ?", "%#{params[:any]}%", "%#{params[:any]}%").order("created_at DESC")
        @total=@channels.total_entries
        arr=[]
            for i in @channels do
                @user_details=User.find(i.user_id)
                pics= rails_blob_url(i.image)
                arr.push({images:pics, content:i, user:@user_details})   
            end
        render :json=>{code:"00", message:arr, total:@total}, status: :ok

    end




    def getSubscribersToYourChannel
        @sub=@post.subscriptions.paginate(page: params[:page], per_page: params[:per_page]).order("created_at DESC")
        @total=@sub.total_entries
        render :json=>{code:"00", message:@sub, total:@total}.to_json(:include=>{:user=>{}}), status: :ok
    end
    

    #check if logged in user is subscribed to a channel
    def checkSubscription
        @check_sub= Subscription.where(user_id:@current_user.id , channel_id:@channel.id )
        if @check_sub.length>0
            render :json=>{subscribed:true, message:@check_sub[0]}, status: :ok
        else
            render :json=>{subscribed:false, message:@check_sub[0]}, status: :ok
        end
    end

    def updateChannelImage
        if @current_user.suspended==false
            @post.image.purge
                if  @post.image.attach(params[:image])
                    render :json=>{code:"00", message:"image updated successfully", image:rails_blob_url(@post.image)}, status: :ok
                else
                    render :json=>{code:"01", message:"error updating image"}
                end
        else
            render :json=>{code:"01", message:"account has been suspended"}
        end
    end


    def getPodcastChannel
        @channels=Channel.paginate(page: params[:page], per_page: params[:per_page]).where(content: 1).order("created_at DESC")
        @total=@channels.total_entries
        arr=[]
            for i in @channels do
                @user_details=User.find(i.user_id)
                pics= rails_blob_url(i.image)
                arr.push({images:pics, content:i, user:@user_details})   
            end
        render :json=>{code:"00", message:arr, total:@total}, status: :ok
    end

    def getVideoChannel
        @channels=Channel.paginate(page: params[:page], per_page: params[:per_page]).where(content: 2).order("created_at DESC")
        @total=@channels.total_entries
        arr=[]
            for i in @channels do
                @user_details=User.find(i.user_id)
                pics= rails_blob_url(i.image)
                arr.push({images:pics, content:i, user:@user_details})   
            end
        render :json=>{code:"00", message:arr, total:@total}, status: :ok
    end

    def getYourVideoChannel
        if @current_user.suspended==true
            render :json=>{code:"01", message:"your account has been suspended"}
        else
           @channel= Channel.where(user_id: @current_user.id, content:2)
           render :json=>{code:"00", message:@channel}, status: :ok
        end
    end

    def getYourPodcastChannel
        if @current_user.suspended==true
            render :json=>{code:"01", message:"your account has been suspended"}
        else
           @channel= Channel.where(user_id: @current_user.id, content:1)
           render :json=>{code:"00", message:@channel}, status: :ok
        end
    end

    private

    def create_params
        params.permit(
           :name, :description, :content, :image
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
