class ChatsController < ApplicationController
  before_action :set_chat, only: %i[show edit update destroy]

  # GET /chats or /chats.json
  def index
    @chats = Chat.all.order(created_at: :desc)
  end

  # GET /chats/1 or /chats/1.json
  def show
  end

  # GET /chats/new
  def new
    @chat = Chat.new
    if turbo_frame_request?
      render partial: "new_chat"
    else
      render :new
    end
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats or /chats.json
  def create
    return unless current_user

    @chat = Chat.new(chat_params.merge(user_id: current_user.id))
    pp chat_params
    respond_to do |format|
      if @chat.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend("chat_rows", partial: "chat_row", locals: { chat: @chat })
        }
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully created." }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully updated." }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat.destroy

    respond_to do |format|
      format.html { redirect_to chats_url, notice: "Chat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat
    @chat = Chat.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def chat_params
    params.require(:chat).permit(:user_id, :text)
    # params.permit(:user_id, :text, :chat)
  end
end
