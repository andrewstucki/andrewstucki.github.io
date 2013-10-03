module Jekyll
  module URLHelper
    def get_baseurl
      baseurl = @context.registers[:site].config['baseurl']
    end
    
    def make_absolute_url(input)
      input = "#{get_baseurl}#{input}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::URLHelper)