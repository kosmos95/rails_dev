class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    begin
      uri = URI.parse(value)
      resp = uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      resp = false
    end
    unless resp == true
      record.errors[attribute] << (options[:message] || "올바른 URL이 아닙니다.")
    end
  end
end

class Hanuri < ApplicationRecord

  mount_uploader :image, ImageUploader
  
  belongs_to :user 
  
  before_destroy :before_destroy 
  
  validates :title, presence: true
  validates :country, presence: true
  validates :url1, :url => true
  validates :url2, :url => true
  validates :url3, :url => true
  validates :url_info, :url => true

  scope :hidden, -> { where("hidden=?", true) } 
  scope :exclude_hidden, -> { where("hidden=?", false) } 
  scope :in_country, ->(country_code) { where("country" => country_code) } 

  def before_destroy
    image.remove!
    image.delete_empty_dirs 
  end
  
end
