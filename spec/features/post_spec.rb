require 'rails_helper'

describe 'navigate' do
  before do
    #@user = User.create(email:'test@test.com', password:'abcdef', password_confirmation:'abcdef', first_name:'john',last_name: 'snow')
    @user = FactoryBot.create(:user)
    login_as(@user, :scope=>:user)
  end
	describe 'index' do
		it 'can be reached successfully' do
      visit posts_path
      expect(page.status_code).to eq(200)
    end

    it 'has a title of Posts' do
      visit posts_path
      expect(page).to have_content(/Posts/)
    end

    it 'has a list of posts' do
      #post1= Post.create!(date: Date.today, rationale:'Post1', user_id: @user.id)
      #post2= Post.create!(date: Date.today, rationale:'Post2', user_id: @user.id)
      post1= FactoryBot.build_stubbed(:post)
      post2= FactoryBot.build_stubbed(:second_post)
      visit posts_path
      expect(page).to have_content(/Rationale|content/)
    end
    
    # it 'has a scope so that only post creators can see their posts' do
    #   other_user = User.create(first_name:'Non', last_name:'Authorized', email:'nonauth@example.com', password: "abcdef",
    #     password_confirmation:"abcdef", phone: "5555555555")
    #   post_from_other_user =Post.create(date: Date.today, rationale:"This post shouldn't be seen", user_id: other_user.id, overtime_request: 3.5)
    #   visit posts_path
    #   expect(page).to_not have_content(/This post shouldn't be seen/)
    # end
end

  describe  'new' do
    it 'has a link from the homepage' do
      visit root_path
      
      click_link("new_post_from_nav")
      expect(page.status_code).to eq(200)
    end
  end

  # describe 'delete' do
  #   it 'can be deleted' do
  #     @post=FactoryBot.create(:post)
  #     visit posts_path
  #     click_link("delete_post_#{@post.id}_from_index")
  #     expect(page.status_code).to eq(200)
  #   end
  # end

  describe 'creation' do
		before do
		
			visit new_post_path
		end
    it 'has a new form that can be reached' do
      expect(page.status_code).to eq(200)
    end

    it 'can be created from new form page' do
      fill_in 'post[date]', with: Date.today
      fill_in 'post[rationale]', with: "Some rationale"
      click_on "Save"
      expect(page).to have_content("Some rationale")
    end

		it 'will have a user associated it' do
			fill_in 'post[date]', with: Date.today
			fill_in 'post[rationale]',with: "User Association"
			click_on "Save"
			expect(User.last.posts.last.rationale).to eq("User Association")
		end
  end

  describe 'edit' do
    before do
      @post= FactoryBot.create(:post)
    end
    # it 'can be reached by clicking edit on index page'  do
      
    #   visit posts_path
    #   click_link("edit_#{@post.id}")
    #   expect(page.status_code).to eq(200)
    # end

    it 'can be edited' do
      visit edit_post_path(@post)
      expect(page.status_code).to eq(200)

      fill_in 'post[date]', with: Date.today
      fill_in 'post[rationale]', with: "Edited content"
      click_on "Save"
      expect(page).to have_content("Edited content")
    end

    it 'can be edited' do
      visit edit_post_path(@post)
      #expect(page.status_code).to eq(200)
      fill_in 'post[date]', with: Date.today
      fill_in 'post[rationale]', with: "Edited content"
      click_on "Save"
      expect(page).to have_content("Edited content")
    end

  end
end
