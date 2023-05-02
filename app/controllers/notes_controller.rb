class NotesController < ApplicationController
  before_action :require_login
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    if current_user && current_user.admin?
      @notes = Note.all
    else
      @notes = current_user.notes
    end
  end

  def show
  end

  def new
    if !session[:user_id]
      redirect_to notes_path, alert: "You have to log in to create a new note"
    else
      @note = Note.new
    end
  end

  def edit
    if !current_user.admin? && @note.user != current_user
      redirect_to notes_path, alert: "You cannot edit another user's note!"
    end
  end

  def create
    @note = current_user.notes.build(note_params)
    if note_collection_id = params[:note][:note_collection_id]
      note_collection = current_user.note_collections.find(note_collection_id)
      @note.note_collections << note_collection
    end
    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(:notes, partial: "notes/note", locals: { note: @note })
        end
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @note.user_id != session[:user_id] && !current_user.admin?
      redirect_to notes_path, alert: "You cannot update another user's note!"
      return
    end

    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to note_url(@note), notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if !current_user.admin? && @note.user != current_user
      redirect_to notes_path, alert: "You do not have permission to delete this note."
    else
      @note.destroy
      respond_to do |format|
        format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def share_note
    flash[:notice] = "Note shared!"
    redirect_to note_path(params[:id])
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content, :image, :user_id)
  end



end
