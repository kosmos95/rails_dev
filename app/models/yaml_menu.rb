require 'yaml' 

class YamlMenu

  MENU_FILE = Rails.root.join("config", "menu_default.yml")
  @@html = nil
  @@data = nil 
  
  def self.html; @@html || make_html end
  
  def self.data; @@data || make_data end

  def self.yaml; File.new(MENU_FILE).read end

  def self.refresh(text = nil)
    File.open(MENU_FILE, 'w') {|f| f.write(text) } unless text.blank?
    @@data = YAML::load(yaml) 
  end

  def self.make_data(text = nil)     
    @@data || refresh(text)
  end 

  def self.make_html(text = nil)     
    make_data(text)
    @@html = @@data.to_a.to_s 
  end 

end
