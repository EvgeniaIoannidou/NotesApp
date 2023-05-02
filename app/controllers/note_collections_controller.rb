class NoteCollectionsController < ApplicationController
  before_action :require_login

  def index
    @note_collections = current_user.note_collections.all
  end

  def new
    @note_collection = current_user.note_collections.new
  end

  def create
    @note_collection = current_user.note_collections.new(note_collection_params)

    if @note_collection.save
      redirect_to note_collections_path, notice: 'Note collection was successfully created.'
    else
      render :new
    end
  end

  def show
    @note_collection = current_user.note_collections.find(params[:id])
    @notes = @note_collection.notes.where.not(note_collection_id: nil)
    if current_user.admin?
      @available_notes = Note.where(note_collection_id: nil)
    else
      @available_notes = current_user.notes.where(note_collection_id: nil)
    end
  end

  def add_note
  @note_collection = current_user.note_collections.find(params[:id])
  @note = Note.find(params[:note_id])

  if @note.update(note_collection_id: @note_collection.id)
    redirect_to note_collection_path(@note_collection), notice: 'Note was successfully added to collection.'
  else
    redirect_to note_collection_path(@note_collection), alert: 'Failed to add note to collection.'
  end
  end

  def remove_note
    @note_collection = current_user.note_collections.find(params[:id])
    @note = @note_collection.notes.find(params[:note_id])

    if @note.destroy
      redirect_to note_collection_path(@note_collection), notice: 'Note was successfully removed from collection.'
    else
      redirect_to note_collection_path(@note_collection), alert: 'Failed to remove note from collection.'
    end
  end

  def destroy
    @note_collection = current_user.note_collections.find(params[:id])
    @note_collection.destroy
    redirect_to note_collections_path, notice: 'Note collection was successfully destroyed.'
  end

  def edit
    @note_collection = NoteCollection.find(params[:id])
  end


  private

  def note_collection_params
    params.require(:note_collection).permit(:name)
  end
end
