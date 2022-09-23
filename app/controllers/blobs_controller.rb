class BlobsController < ApplicationController
  def show
    blob = ActiveStorage::Blob.find_signed!(params[:id])
    if params[:w]
      redirect_to blob.representation(resize_to_limit: [params[:w].to_i, nil])
    elsif params[:h]
      redirect_to blob.representation(resize_to_limit: [nil, params[:h].to_i])  
    else
      redirect_to blob
    end
  rescue ActiveStorage::UnrepresentableError
    redirect_to '/nopreview.png'
  end
end