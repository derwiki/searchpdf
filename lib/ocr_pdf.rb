require 'google/cloud/vision'
require 'log_helper'

module GoogleCloudVision
  class OcrPdfService
    attr_accessor :pdf_filename

    def initialize(pdf_filename)
      fail "GOOGLE_CLOUD_KEYFILE env variable required" unless ENV['GOOGLE_CLOUD_KEYFILE']
      fail "Input must be PDF" unless pdf_filename&.split('.')&.last&.downcase == 'pdf'
      self.pdf_filename = pdf_filename
      log :page_count, self.page_count
    end

    def perform
      [].tap do |pages|
        self.page_count.times do |i|
          tempfile = Tempfile.new(%w(image .jpg))
          begin
            log :writing_image, tempfile.path
            write_pdf_page_to_jpg(i, tempfile.path)
            log :compressing_image
            log :loading_image
            image = vision.image(tempfile.path)
            image.context.languages = ['en-US']
            log :annotating_image
            annotation = vision.annotate(image, document: true)
          ensure
            tempfile.close
            tempfile.unlink
          end

          log :extracting_text
          text = annotation.text.to_s
          log self.pdf_filename, i, text
          yield [text, i] if block_given?
          pages << text
        end
      end
    end

    protected

      def page_count
        @page_count ||= `gs -q -dNODISPLAY -c "(#{self.pdf_filename}) (r) file runpdfbegin pdfpagecount = quit";`.to_i
      end

    private

      def vision
        @vision ||= Google::Cloud::Vision.new(project: ENV['GOOGLE_CLOUD_PROJECT_ID'])
      end

      def write_pdf_page_to_jpg(page_num, file_path)
        command = <<-EOS.squish
          gs -sDEVICE=jpeg
             -dBATCH
             -dNOPAUSE
             -r225
             -sOutputFile=#{file_path}
             -dFirstPage=#{page_num+1}
             -dLastPage=#{page_num+1}
             -dJPEGQ=40
             #{self.pdf_filename}
        EOS
        `#{ command }`
        log :file, file_path, :page_num, page_num, :bytes, File.size(file_path)
      end
  end
end
