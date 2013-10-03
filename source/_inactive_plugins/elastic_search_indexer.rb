require 'tire'
require 'sanitize'
 
module Jekyll
    class ElasticSearchIndexer < Generator
        safe true
 
        def generate(site)
 
            Tire::Configuration.url(site.config['search_server'])
 
            Tire.index site.config['search_index'] do
                delete
                create :mappings => {
                    :post => {
                        :properties => {
                            :url      => { :type => 'string'},
                            :title    => { :type => 'string', :boost => 2.0,            :analyzer => 'snowball'  },
                            :tags     => { :type => 'string', :analyzer => 'keyword'                             },
                            :content  => { :type => 'string', :analyzer => 'snowball'                            }
                        }
                    },
 
                }
 
                site.posts.each do |post|
                    store :type => 'post',
                        :title => post.data['title'],
                        :content => Sanitize.clean(post.content),
                        :categories => post.categories,
                        :tags => post.tags,
                        :url => post.url
 
 
                end
            end
        end
    end
end