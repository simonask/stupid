
if RUBY_VERSION >= "1.9.0"

class String
	alias each each_line
end

end