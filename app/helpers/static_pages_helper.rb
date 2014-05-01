module StaticPagesHelper
	def gcal_link(task)
		puts "IN GCAL"
		# Returns a copy of str with the all occurrences of pattern substituted for the second argument
		if (task.due_at != nil)
			puts "IN GCAL LINK NOT NIL"
			s = [task.description, task.due_at.in_time_zone("UTC").iso8601.gsub(/[-:]/, ''),
			task.due_at.advance(minutes: 30).in_time_zone("UTC").iso8601.gsub(/[-:]/, '')]
		else
			s = [task.description, Day.find(task.day_id).date.iso8601.gsub(/[-:]/, ''),
			Day.find(task.day_id).date.tomorrow.iso8601.gsub(/[-:]/, '')]
		end

		s = s.map {|x| URI.escape(x) }

		'http://www.google.com/calendar/render?action=TEMPLATE&text=%s&dates=%s/%s&location&details' % s
		#'http://www.google.com/calendar/event?action=TEMPLATE&text=%s&dates=%s/%s' % s
	end
end
