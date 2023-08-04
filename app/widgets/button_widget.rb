class ButtonWidget < ActionWidget::Base
  property :caption,
    converts: :to_s,
    required: true

  property :target,
    converts: :to_s,
    accepts: lambda { |uri| URI.parse(uri) rescue false },
    required: true

  property :type,
    converts: :to_sym,
    accepts: [:regular, :accept, :cancel],
    default: :regular

  property :size,
    converts: :to_sym,
    accepts: [:small, :medium, :large],
    default: :medium

  def render
    content_tag(:a, caption, href: target, class: css_classes)
  end

protected

  def css_classes
    css_classes = ['btn']
    css_classes << "btn-#{size}" unless size == :regular
    css_classes << "btn-#{type}" unless type == :medium
    css_classes
  end
end
