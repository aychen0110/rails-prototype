# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :fog

  include CarrierWave::MimeTypes
  process :set_content_type

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
     %w(jpg jpeg gif png)
  end


  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fit => [250, 250]
    process :get_meta_information

    def meta
      @meta
    end
  end

  def get_meta_information

    debugger

    if (@file)
      img = ::MiniMagick::Image::read(@file)

      @meta = Hash.new

      # TODO: properties instead of array
      @meta = { :height => img[:height], :width => img[:width], :format => img[:format] }
    end
  end


end
