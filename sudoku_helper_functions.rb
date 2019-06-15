#takes an array of arrays, 
#where each nested array represents 
#one file in the puzzle

	def solve_puzzle(puzzle) 
		#re-sort the arrays
		joined_puzzle = puzzle.flatten
		square_puzzle = [[],[],[],[],[],[],[],[],[]]
		joined_puzzle.flatten.each_index do |nth_space|
			square_puzzle[nth_space/9].push(joined_puzzle[nth_space])
		end
		find_next_state(joined_puzzle)
	end


	def find_next_state(base_puzzle)
		# Construct the square version of the puzzle
		square_puzzle = [[],[],[],[],[],[],[],[],[]]
		base_puzzle.each_index do |nth_space|
			square_puzzle[nth_space/9].push(base_puzzle[nth_space])
		end

		# We reorganize the puzzle so we can have unique sets to check against
		sorted_by_rank = square_puzzle
		sorted_by_file = square_puzzle.transpose
		sorted_by_box = [[],[],[],[],[],[],[],[],[]]
		base_puzzle.each_index do |nth_space|
			box_number = (nth_space/27)*3 + (nth_space%9)/3
			if nth_space%9<3
				sorted_by_box[box_number].push(base_puzzle[nth_space])
			elsif nth_space%9<6
				sorted_by_box[box_number].push(base_puzzle[nth_space])
			else				
				sorted_by_box[box_number].push(base_puzzle[nth_space])
			end
		end

		# This is a recursion so we should check if we already found a solution
		if base_puzzle.map{|x| x>0?1:0}.sum==81
			puts "solution" 
			square_puzzle.each do |row|
				p row
			end
			return 1
		end

		# Create the sets of allowed numbers available for each space 
		all_available_numbers = [*1..9]
		allowed_numbers_in_space = base_puzzle.dup
		base_puzzle.each_index do |nth_space|
			if base_puzzle[nth_space]<=0
				set_from_rank = sorted_by_rank[nth_space/9]
				set_from_file = sorted_by_file[nth_space%9]
				box_number = (nth_space/27)*3 + (nth_space%9)/3
				set_from_box = sorted_by_box[box_number]
				this_space_set = (((all_available_numbers - set_from_rank) - set_from_file) - set_from_box)
				if this_space_set==[] 
					return 0 
				end
				allowed_numbers_in_space[nth_space] = this_space_set
			else
				allowed_numbers_in_space[nth_space] = nth_space
			end
		end

		# If none of the spaces have an obvious one step solution run the nontrivial method else trivial
		if allowed_numbers_in_space.map{|x| x.size==1?1:0}.sum==0
			# p allowed_numbers_in_space
			do_nontrivial_solution(allowed_numbers_in_space,base_puzzle)
		else
			do_trivial_solution(allowed_numbers_in_space,base_puzzle)
		end
	end

	def do_trivial_solution(allowed_numbers_in_space,joined_puzzle)
		allowed_numbers_in_space.each_index do |nth_space|
			if joined_puzzle[nth_space]==0 &&
				allowed_numbers_in_space[nth_space].class==Array &&
					allowed_numbers_in_space[nth_space].size==1
						trivial_solution=allowed_numbers_in_space[nth_space][0]
						joined_puzzle[nth_space]=trivial_solution
						# puts "TRIVIAL STEP: add #{trivial_solution} in #{nth_space}th space"
						break
			end
		end
		find_next_state(joined_puzzle.flatten)
	end

	def do_nontrivial_solution(allowed_numbers_in_space,joined_puzzle)
		smallest_set = allowed_numbers_in_space.map { |x| 
			x.class==Array ? x.size : 10
		}.min
		allowed_numbers_in_space.each_index do |nth_space|
			this_space_solutions = allowed_numbers_in_space[nth_space]
			if joined_puzzle[nth_space] ==0 &&
				this_space_solutions.class==Array &&
					this_space_solutions.size==smallest_set
						this_space_solutions.each do |element_in_set|
							joined_puzzle[nth_space]=element_in_set
							# puts "NONTRIVIAL STEP: add #{element_in_set} in #{nth_space}th space"
							find_next_state(joined_puzzle.flatten)
						end
			end
			if this_space_solutions.size==smallest_set
				break
			end
		end
	end

	