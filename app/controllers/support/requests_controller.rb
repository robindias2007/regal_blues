# frozen_string_literal: true

class Support::RequestsController < ApplicationController
  def index
    @requests = Request.includes(:address, :request_designers, :offers, :sub_category).order(created_at: :desc).all
    @conversation = Conversation.new
  end

  def chat
    @skip_header = true;
    @convo_id = Conversation.find(params[:id])
    @message = Message.new()
    update_read_count = Conversation.find(@convo_id.id).messages.update_all(read:true)
    # request_id = Request.find(params[:id]).id
    # @convo_id = Request.find(request_id).user.conversations
  end

  def chat_post
    conversation = Conversation.find(params[:id])
    @message = conversation.messages.new(message_params)
    @message.sender_id = current_support.id
    if @message.save!

      # render json: {message: Message.as_a_json(message)}, status: 201
      #render json: {message: message}, status: 201
      @message.update_attributes(body:params[:message][:body], conversation_id:params[:message][:conversation_id], attachment:params[:message][:attachment])
      redirect_to chat_path(params[:message][:conversation_id])
      else
      redirect_to root_url
      #render json: {message: message.errors}, status: 400
    end
  end


  def show
    @request = Request.find(params[:id])
    request = Request.find(params[:id]) rescue nil
    if params[:commit] == "Update"
      request.update(description:params[:request][:description], max_budget:params[:request][:max_budget])
      redirect_to support_request_path(request)
    end

    @request_image = RequestImage.new
    request_image = RequestImage.new(request_image_params) rescue nil
    if request_image.present?
      if request_image.save
        request_image.update(image:"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAASNSURBVDhPlZR7TNVlGMdPK/MydeampWVbqaCowLgEKpxz4HAu3A9XwRIERA5ICIoSQUqJgTgVNeGU4iUUxVszRFyokUMNMTUvE8ecqYma1MSsnMpnve+Ll9Xsj8727Pf+fjvvZ+/zfL/fV3NtS29u1vaiY+vLXP6yLxfWDeBkxSscWTGEA0uGUffJm9QWvs3GeQ5UZjmx3ObC4iR3Ct71Yk70ZNJD9Uw3BxCrtxAyMRTNjW29uLP7BTp3vMjVzX24uL4/pysHcbR8CAcFcO+iEWz/6C02zXfAPlsA051ZnOxGoQDOjZlMRphOAaf4WQiVwOs1vbm94yVuiVNeqe5DW1V/TlXKEw7mQOnQHmDh/wBe2tSPK+JkP1X3pX1jf87a+9K6agBHV42gaeU49hS9Tm3Bs5aXznDi42kTyI9zf37L59cOVKe6UDWAMxW9ObfJidYvxnD2qwQOlruye8Eb1OSPZP1cRz7LdKI804sVs82UZASTHTkJW4ieRFMAMToLwd4C+MOawZwSIpysGMSJNUO4dGgeLWs96Di3iz0LX2WHmF913mjsWaOoyPHkzu3rdFxuY0lWJJlh3swM9mOa0Ui0NpAgrzA0zcuHckQIcLisH2d3RnL9xxqaVo3nwf3f2VvmSXXucDbkOrI6YzQVc32Rv9PN+0kzjiLTqiUl0J+pBhORvkFY3glH01g6XNmjoagP5xty+bOrg/oSR7Gtm/aWbVTaBvF59lhWpDmycrZWAU801ZNmHi/mJwUxEOdnJnxyMEYPK5qvhc/qhJK7PhzI8doZasN3GxNpa65S6332VMoSXqMsZRzLMvXqW2vTPlICnEl90q4uUAni7xaBZptQcLsw7ta84ewp9ab70QPudl5lZ4mJP+7e5uGD+2wospIXPoySND8FbDnUQILelSSLgXh/MxE+st0wdC5RaDbkOihLyLJnDKXtWK3adLG1js3FEfx1r0u9V5fNYkGilu7ubo4d3E+8rzvvBRiFuoHCfyEEuFvxdY5GU5E1jkphWFmr00dhn+NOV+c1Bfm+YT1L031padxJ582fOf5tPY8ePqT5mwaiJnoKM5uxitnJ0+ldI3uAy9JcRD6dH5crxdNGUpkXxK+3riromWP7yY/3wmaZwMKZsepbc2MjoR7eSlnpPYOYnYQpYLEIugz74iQ35HrRdE/yY8awKEXH4bot3LvbxW+/3KC+pop1S4sVcHf1FozOk5QQUlmtmN1TYMFUL5VLWXKdH+/NB3GTyInwUNbIifGnMDWemaFm7KWfKmBGXDImNyMmj3AlhM9jmALmiDzKTD6p7CgfsiJ8lWlnWf17rGHQMj9pOpfb21lWVIbfeD0mTys613/CFNAmwi0Nmi5uDZt4polsSkiyxY/3Y6MosNlYkJnN8qJSUqOT0Y7Vqzb/fbKnQBlseVtIxyeKZ4J4l2aVcYrViUj5mAibaMbgYsDfxaIEkDN7HkwB5bUja8rjp7w1okTQI4SCMk5y8NIW0mdPrPFfMFmaECF7iDBmT4UqG8hbQwZdtibjJNuTf/aZ8HzIs4rmb5yMh6esFeU8AAAAAElFTkSuQmCC") 
        redirect_to support_request_path(request)
      end
    end
  end

  def approve
    request = Request.find(params[:support_request_id])
    request.update!(status: :active)
    render json: { message: 'Request approved' }, status: 200
  end

  def reject
    request = Request.find(params[:support_request_id])
    request.update!(status: :unapproved)
    render json: { message: 'Request unapproved' }, status: 200
  end

  def show_request_quo
    @request = Request.find(params[:id])
  end

  private
  def message_params
    params.require(:message).permit(:body, :attachment, :conversation_id)
  end

  def request_image_params
    params.require(:request_image).permit(:image, :request_id, :color, :serial_number)
  end
end
