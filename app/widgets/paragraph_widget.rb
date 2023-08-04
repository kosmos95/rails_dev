class ParagraphWidget < ActionWidget::Base
  def render(content, &block)
    content = capture(&block) if block
    content_tag(:p, content, class: options[:class])
  end
end
