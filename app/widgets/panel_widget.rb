require 'action_widget'

class PanelWidget < ActionWidget::Base
  property :title, required: true, converts: :to_s

  def render(&block)
    content_tag(:div, class: 'panel') do
      content_tag(:h2, title, class: 'title') +
        content_tag(:div, class: 'content', &block)
    end
  end
end
