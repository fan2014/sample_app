require 'spec_helper'

describe "Micropost pages" do
  
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  
  before { sign_in user }
  
  describe "pagination" do 
    before  do 
      51.times { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }
      visit root_path
    end
    
    it "should list each micropost" do
      Micropost.paginate(page: 1).each do |m|
        expect(page).to have_content(m.content)
      end
    end
  end
  
  describe "micropost creation" do
    before { visit root_path }
    
    describe "with invalid information" do
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end
      
      describe "error message" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end
    
    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
    
    describe "micropost destruction" do
      before { FactoryGirl.create(:micropost, user: user) }
       
      describe "as correct user" do
        before { visit root_path }
        it "should delete a micropost" do
         expect { click_link "delete" }.to change(Micropost, :count).by(-1)
        end 
      end
      describe " as wrong user" do
        before do
          anotherUser = FactoryGirl.create(:user) 
          FactoryGirl.create(:micropost, user: anotherUser, content: "This is Fan!")
          visit user_path(anotherUser)
        end
        
        it { should_not have_link('delelte') }
        
      end
    end
  end
end
