10.times do
  condition = {}
  (1..12).each do |n|
    if rand(100) % 4 == 1
	  condition["q_#{n}"] = "a_#{n}"
	elsif rand(100) % 4 == 2
	  condition["q_#{n}"] = "a\nb_#{n}"
	elsif rand(100) % 4 == 3
	  condition["q_#{n}"] = 1 + rand(5)
	else
	  list = [1, 2, 3, 4, 5]
	  condition["q_#{n}"] = list.sort_by{rand}[0..rand(5)]
	end
  end

  Answer.create!(
	condition.merge(
	  :user_id => 1,
	  :enquete_id => 1
	)
  )
end

