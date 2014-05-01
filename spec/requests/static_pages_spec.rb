require 'spec_helper'
describe "Static pages" do
	describe "Home page" do
		it "should have the content 'Task Manager'" do
			visit root_path
			expect(page).to have_content('Task Manager')
		end

		it "should have right title" do
			visit root_path
			expect(page).to have_title("Task Manager | Home")
		end
	end

	describe "Help page" do
		it "should have the content 'Help'" do
			visit '/help'
			expect(page).to have_content('Help')
		end

		it "should have right title" do
			visit '/help'
			expect(page).to have_title("Task Manager | Help")
		end
	end

	describe "About page" do
		it "should have the content 'About Us'" do
			visit '/about'
			expect(page).to have_content('about')
		end

		it "should have right title" do
			visit '/about'
			expect(page).to have_title("Task Manager | About")
		end
	end
end