class TestsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: {:yidly => 'go'}}
    end
  end
end
