module Api
  module V1
    class DocumentsController < ApplicationController

      def index
        documents = Document.all
        render json: DocumentSerializer.new(documents).serialized_json
      end

      def show
        document = Document.find_by(country_id: params[:country_id])

        render json: DocumentSerializer.new(document).serialized_json
      end

      private

      def document_params
        params.require(:document).permit(:document_type, :required, : antigen, :pcr, :validity, :data, :country_id)
      end

    end
  end
end