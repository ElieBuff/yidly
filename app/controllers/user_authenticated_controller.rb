class UserAuthenticatedController < ApplicationController
  before_filter :authenticate_user!
  before_filter :correct_id
  before_filter :correct_user
  before_filter :set_current_object

  def correct_id
    respond_to do |format|
      format.json { render json: {:errors => ["incorrect id"]}, status: :unprocessable_entity }
    end unless (params[:id].nil? or controller_name.classify.constantize.find_by_id(params[:id]))
  end

  def correct_user
    respond_to do |format|
      format.json { render json: {:errors => ["incorrect user"]}, status: :unprocessable_entity }
    end unless (params[:id].nil? or controller_name.classify.constantize.find(params[:id]).user == current_user)
  end

  def set_current_object
    instance_variable_set("@current_#{controller_name.chop}", controller_name.classify.constantize.find(params[:id])) unless params[:id].nil?
  end
end


