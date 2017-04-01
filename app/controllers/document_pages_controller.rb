class DocumentPagesController < ApplicationController
  before_action :set_document_page, only: [:show, :edit, :update, :destroy]

  # GET /document_pages
  def index
    @document_pages = DocumentPage.all
  end

  # GET /document_pages/1
  def show
  end

  # GET /document_pages/new
  def new
    @document_page = DocumentPage.new
  end

  # GET /document_pages/1/edit
  def edit
  end

  # POST /document_pages
  def create
    @document_page = DocumentPage.new(document_page_params)

    if @document_page.save
      redirect_to @document_page, notice: 'Document page was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /document_pages/1
  def update
    if @document_page.update(document_page_params)
      redirect_to @document_page, notice: 'Document page was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /document_pages/1
  def destroy
    @document_page.destroy
    redirect_to document_pages_url, notice: 'Document page was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document_page
      @document_page = DocumentPage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def document_page_params
      params.require(:document_page).permit(:document_id, :page_number, :text)
    end
end
