module ApplicationHelper
	WillPaginate.per_page = 10

	#Returns the full title on a per-page basis.
	def full_title(page_title)
		base_title = "The Blog of the Future"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end

	def tag_cloud(tags, classes)
      max = tags.sort_by(&:count).last
      tags.each do |tag|
      index = tag.count.to_f / max.count * (classes.size - 1)
      yield(tag, classes[index.round])
    end
  end
end
