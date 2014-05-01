FactoryGirl.define do
	factory :user do
		# sequence(:name) { |n| "Person #{n}" }
		# sequence(:email) { |n| "person_#{n}@example.com"}
		name "Derrick Mar"
		email "derrickmar1215@berkeley.edu"
		password "foobar"
		password_confirmation "foobar"

		factory :admin do
			admin true
		end
	end

	factory :task do
		sequence(:description) { |n| "Task #{n}"}
		sequence(:day_id, 1..15) do |n|
			n
		end
	end
end