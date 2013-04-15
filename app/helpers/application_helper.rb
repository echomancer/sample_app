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
end
