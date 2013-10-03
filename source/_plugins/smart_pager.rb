module Jekyll
  module SmartPager
    
    def smart_page(total, current)
      lower_bounds = current - 2
    	upper_bounds = current + 2
    	if lower_bounds < 1
    		upper_bounds -= lower_bounds
    		lower_bounds = 1
    	end
    	if upper_bounds > total
    		lower_bounds -= (upper_bounds-total)
    		upper_bounds = total
    	end
    	if lower_bounds <= 6
    		leading = []
    		upper_bounds = [5, [current+2, upper_bounds].min].max
    		lower_bounds = 1
    	else
    		leading = (1..2).to_a
    	end
    	if upper_bounds >= total-5
    		trailing = []
    		if leading.empty?
    			lower_bounds = 1
    			upper_bounds = total
    		else
    			lower_bounds = [total-4, [current-2, lower_bounds].max].min
    			upper_bounds = total
    		end
    	else
    		trailing = (total-1..total).to_a
    	end
    	main_range = (lower_bounds..upper_bounds).to_a
    	leading << false if not leading.empty?
    	trailing = [false] + trailing if not trailing.empty?
    	return leading+main_range+trailing
    end
    
  end
end

Liquid::Template.register_filter(Jekyll::SmartPager)