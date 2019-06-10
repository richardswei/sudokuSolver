#takes an array of arrays, 
#where each nested array represents 
#one file in the puzzle

def sudoku_solver(puzzle) 
	#re-sort the arrays
	sorted_by_rank = puzzle
	sorted_by_file = puzzle.transpose
	sorted_by_box = [[],[],[],[],[],[],[],[],[]]

	joined_puzzle = puzzle.flatten
	joined_puzzle.each_index do |nth_space|
		box_number = (nth_space/27)*3 + (nth_space%9)/3
		if nth_space%9<3
			sorted_by_box[box_number].push(joined_puzzle[nth_space])
		elsif nth_space%9<6
			sorted_by_box[box_number].push(joined_puzzle[nth_space])
		else				
			sorted_by_box[box_number].push(joined_puzzle[nth_space])
		end
	end
	find_next_state(joined_puzzle,sorted_by_rank,sorted_by_file,sorted_by_box)
end


def find_next_state(joined_puzzle,sorted_by_rank,sorted_by_file,sorted_by_box)
	all_available_numbers = [*1..9]
	if joined_puzzle.map{|x| x>0?1:0}.sum==81
		puts "solution" 
		p joined_puzzle
		# break
	end
	allowed_numbers_in_space = joined_puzzle
	joined_puzzle.each_index do |nth_space|
		if joined_puzzle[nth_space]<=0
			set_from_rank = sorted_by_rank[nth_space/9]
			set_from_file = sorted_by_file[nth_space%9]
			box_number = (nth_space/27)*3 + (nth_space%9)/3
			set_from_box = sorted_by_box[box_number]
			this_space_set = (((all_available_numbers - set_from_rank) - set_from_file) - set_from_box)
			if this_space_set.size == 0 
				puts "Attempt Reached Dead End"
				break
			end
			allowed_numbers_in_space[nth_space] = this_space_set
		end
	end
	if allowed_numbers_in_space.map{|x| x.size==1?1:0}.sum==0
		# break
		# do_nontrivial_solution(allowed_numbers_in_space,joined_puzzle,sorted_by_rank,sorted_by_file,sorted_by_box,2)
	else
		do_trivial_solution(allowed_numbers_in_space,joined_puzzle,sorted_by_rank,sorted_by_file,sorted_by_box)
	end
end

def do_trivial_solution(allowed_numbers_in_space,
	joined_puzzle,
	sorted_by_rank,
	sorted_by_file,
	sorted_by_box)
	allowed_numbers_in_space.each_index do |nth_space|
		if allowed_numbers_in_space[nth_space].class==Array && allowed_numbers_in_space[nth_space].size==1
			trivial_solution=allowed_numbers_in_space[nth_space][0]
			joined_puzzle[nth_space]=trivial_solution
			sorted_by_rank[nth_space/9].push(trivial_solution)
			sorted_by_file[nth_space%9].push(trivial_solution)
			sorted_by_box[(nth_space/27)*3 + (nth_space%9)/3].push(trivial_solution)
		end
	end
	find_next_state(joined_puzzle.flatten,
		sorted_by_rank,
		sorted_by_file,
		sorted_by_box)
end

# def do_nontrivial_solution(allowed_numbers_in_space,
# 	joined_puzzle,
# 	sorted_by_rank,
# 	sorted_by_file,
# 	sorted_by_box,
# 	next_smallest_set)
# 	nontrivial_solution_counter=0
# 	allowed_numbers_in_space.each_index do |x|
# 		if allowed_numbers_in_space[x].class==Array && allowed_numbers_in_space[x].size==next_smallest_set
# 			this_space_solutions = allowed_numbers_in_space[x]
# 			this_space_solutions.each do |element_in_set|
# 				joined_puzzle[x]=element_in_set
# 				sorted_by_rank[nth_space/9].push(element_in_set)
# 				sorted_by_file[nth_space%9].push(element_in_set)
# 				sorted_by_box[(nth_space/27)*3 + (nth_space%9)/3].push(element_in_set)
# 				find_next_state(joined_puzzle,sorted_by_rank,sorted_by_file,sorted_by_box)
# 				nontrivial_solution_counter++
# 			end
# 		end
# 	end
# 	if nontrivial_solution_counter==0
# 		next_smallest_set++
# 		do_nontrivial_solution(allowed_numbers_in_space,joined_puzzle,sorted_by_rank,sorted_by_file,sorted_by_box,next_smallest_set)
# 	end
# end




sudoku_solver([[4,9,3,0,5,1,8,7,6],
	[8,6,0,3,9,7,1,2,4],
	[2,0,0,8,6,4,3,5,9],
	[5,3,8,4,7,9,2,6,1],
	[6,7,9,1,2,8,4,3,5],
	[1,2,4,6,3,5,9,8,7],
	[7,5,2,9,1,3,6,4,8],
	[9,8,6,5,4,2,7,1,3],
	[3,4,1,7,8,6,5,9,2]
])