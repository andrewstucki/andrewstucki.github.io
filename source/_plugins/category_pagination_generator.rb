module Jekyll

  class CategoryPagination < Generator
  
    safe true
    priority :low

    def generate(site)
      site.categories.each do |category|
        build_subpages(site, "category", category) if site.config['paginated_categories'].include? category[0]
      end

      # site.tags.each do |tag|
      #   build_subpages(site, "tag", tag)
      # end
    end

    def build_subpages(site, type, posts) 
      posts[1] = posts[1].sort_by { |p| -p.date.to_f }     
      atomize(site, type, posts)
      paginate(site, type, posts)
    end

    def atomize(site, type, posts)
      path = "/#{type}/#{posts[0]}"
      atom = AtomPage.new(site, site.source, path, type, posts[0], posts[1])
      site.pages << atom
    end

    def paginate(site, type, posts)
      pages = CategoryPager.calculate_pages(posts[1], site.config['paginate'].to_i)
      (1..pages).each do |num_page|
        pager = CategoryPager.new(posts[0], site, num_page, posts[1], pages)
        path = "/#{type}/#{posts[0]}"
        if num_page > 1
          path = path + "/page#{num_page}"
        end
        newpage = GroupSubPage.new(site, site.source, path, type, posts[0])
        newpage.pager = pager
        site.pages << newpage
      end
    end
  end

  class GroupSubPage < Page
    def initialize(site, base, dir, type, val)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts', val), "layout.html")
      self.data["grouptype"] = type
      self.data[type] = val
    end
  end
  
  class AtomPage < Page
    def initialize(site, base, dir, type, val, posts)
      @site = site
      @base = base
      @dir = dir
      @name = 'atom.xml'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts', val), "layout.xml")
      self.data[type] = val
      self.data["grouptype"] = type
      self.data["posts"] = posts[0..9]
    end
  end
  
  class CategoryPager < Pager
    def self.paginate_path(category, site, num_page)
      return nil if num_page.nil?
      return Generators::Pagination.first_page_url(site) if num_page <= 1
      format = "category/#{category}/page:num"
      format = format.sub(':num', num_page.to_s)
      ensure_leading_slash(format)
    end
    
    def initialize(category, site, page, all_posts, num_pages = nil)
      super(site, page, all_posts, num_pages)
      @next_page_path = CategoryPager.paginate_path(category, site, @next_page)
    end
  end
end