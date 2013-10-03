module Jekyll
  class DefaultPostImage < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      context.registers[:site].config['default_post_image']
    end
  end
end

Liquid::Template.register_tag('default_post_image', Jekyll::DefaultPostImage)