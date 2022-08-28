# frozen_string_literal: true

class Api::V1::DocsController < ApplicationController
  layout 'api_docs'

  def show
  end

  def openapi
    file_path = Rails.root.join(
      'app',
      'api_docs',
      'v1.yml'
    )

    send_file file_path
  end
end
