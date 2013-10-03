module Jekyll
  
  class Page

    attr_accessor :archiver
     
    def render(layouts, site_payload)
      payload = {
        "page" => self.to_liquid,
        'paginator' => pager.to_liquid,
        'archives' => archiver.to_liquid
      }.deep_merge(site_payload)
      
      do_layout(payload, layouts)
    end
  end
  
  class ArchivePage < Page
    def initialize(site, posts_by_year)
      @site = site
      @base = site.source
      # I simply write the archives.html file in the _site root
      @dir = "/archives"
      @name = "index.html"
      
      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'archives.html')
      # hash keyed on normalized times, mapped to array of posts
      self.data['posts_by_year'] = posts_by_year
    end
  end


  class ArchiveGenerator < Generator
    
    safe true
    priority :lowest

    def group_by_year(posts)
      posts_by_year = {}
      posts.reverse.each do |post|
        year = Time.utc(post.date.year)
        month = Time.utc(post.date.year, post.date.month)
        if posts_by_year.has_key?(year)
          if posts_by_year[year].has_key?(month)
            posts_by_year[year][month] << post
          else
            posts_by_year[year][month] = [post]
          end
        else
          posts_by_year[year] = { month => [post] }
        end
      end
      return posts_by_year
    end

    def generate(site)
      posts_by_year = group_by_year(site.posts)

      archives = ArchivePage.new(site, posts_by_year)
      site.pages << archives
      site.pages.dup.each do |page|
        page.archiver = Archiver.new(posts_by_year)
      end
      
      archives.render(site.layouts, site.site_payload)
      archives.write(site.dest)
    end
  end
  
  class Archiver
    attr_reader :months

    def initialize(grouped_posts)
      @months = []
      grouped_posts.each do |year, months|
        months.each do |timestamp, posts|
          @months << [timestamp, posts.count]
        end
      end
    end
    
    def to_liquid
      {
        'months' => months,
      }
    end

  end

end