require "rails_helper"

RSpec.feature "Users can only see the appropriate links" do
	let(:user) { create(:user) }
	let(:admin) { create(:user, :admin) }
	let(:project) { create(:project) }

	context "annonymous users" do
		scenario "cannot see the New Project link" do
			visit root_path
			expect(page).not_to have_link "New Project"
		end
	end

	context "non-admin users (project viewers)" do
		before do
		 login_as(user)
		 assign_role!(user, :viewer, project)
		end

		scenario "cannot see the New Project link" do
			visit root_path
			expect(page).not_to have_link "New Project"
		end

		scenario "cannot see the Edit Project link" do 
			visit project_path(project)
			expect(page).not_to have_link "Edit Project"
		end

		scenario "cannot see the New Ticket link" do 
			visit project_path(project)
			expect(page).not_to have_link "New Ticket"
		end
	end

	context "admin users" do
		before { login_as(admin) }

		scenario "can see the New Project link" do
			visit root_path
			expect(page).to have_link "New Project"
		end

		scenario "cannot see the Delete Project link" do
			visit project_path(project)
			expect(page).to have_link "Delete Project"
		end

		scenario "can see the Edit Project link" do 
			visit project_path(project)
			expect(page).to have_link "Edit Project"
		end

		scenario "can see the New Ticket link" do 
			visit project_path(project)
			expect(page).to have_link "New Ticket"
		end
	end
end
