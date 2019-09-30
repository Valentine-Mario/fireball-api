class ChannelsController < ApplicationController
    before_action :authorize_request, except:[]

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
        #render :json=>{code:"00", message:@current_user, pics:pics}.to_json(:include=>{:channels=>{}}), status: :ok
    end

    private

    def create_params
        params.permit(
           :name, :description, :content
          )
    end
end
