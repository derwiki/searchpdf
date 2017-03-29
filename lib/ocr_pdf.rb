require 'google/cloud/vision'

class OcrPdf
  attr_accessor :pdf_filename

  def initialize(pdf_filename)
    fail "GOOGLE_CLOUD_KEYFILE env variable required" unless ENV['GOOGLE_CLOUD_KEYFILE']
    fail "Input must be PDF" unless pdf_filename&.split('.')&.last&.downcase == 'pdf'
    self.pdf_filename = pdf_filename
  end

  def perform
    [].tap do |pages|
      Magick::ImageList.new(self.pdf_filename).each_with_index do |page_img, i|
        tempfile = Tempfile.new(%w(image .jpg))
        begin
          log :writing_image, tempfile.path
          page_img.write(tempfile.path)
          image = vision.image(tempfile.path)
          annotation = vision.annotate(image, document: true)
          text = annotation.text.to_s
          log self.pdf_filename, i, text
          pages << text
        ensure
          tempfile.close
          tempfile.unlink
        end
      end
    end
  end

  private

    def vision
      @vision ||= Google::Cloud::Vision.new(project: ENV['GOOGLE_CLOUD_PROJECT_ID'])
    end
end
