module Jekyll

  class BannerImages < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      @site = context.registers[:site]
      process_posts
    end

    def process_posts
      images = []
      @site.posts.each do |post|
        images << generate_banner_image(post, post.data['featured']) if post.data['featured']
      end
      images.compact!
      images.join("\n")
    end

    def generate_banner_image(post, image)
      "<li><a href=\"#{post.url}\"><img src=\"#{image}\" alt=\"#{post.title}\" /></a></li>"
    end
    
  end

end

Liquid::Template.register_tag('banner_images', Jekyll::BannerImages)