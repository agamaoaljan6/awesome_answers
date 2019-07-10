require 'rails_helper'

# To generate this file after you have already created
# the model, run:
# rails g rspec:model JobPost

# To run your tests with rspec, do:
# rspec
# To get detailed information about the running tests, do:
# rspec -f d
RSpec.describe JobPost, type: :model do

  def job_post 
  @job_post ||= JobPost.new(title: "Awesome Job", description:"Some valid job description")
  end 
# The "describe" is used to group related tests 
# together. It's primarily an organizational tool. 
# All of the grouped tests should be written within 
# the block of the method. 
  describe "validates" do
    # 'it' is another rspec keyword which is used to 
    # define an "example" (test case). 
    # The string argument often uses the word "should"
    # and is meant to describe what specific behavior 
    # should happen inside the block. 
    it("requires a title") do
    # Given
    # An instance of a JobPost 
    jp = job_post
    jp.title = nil
    # When
    # validations are triggered 
    jp.valid?
    # Then
    # There's an error related to the title
    # in the error object.

    # The following will pass the test if the
    # errors.messages hash has a key named :title.
    # This only occurs when a "title" validation fails
    expect(jp.errors.messages).to(have_key(:title))  
    end

    it("requires a unique title") do
      persisted_jp = JobPost.create(title: "Imagination Engineer", description:"Be an imagination Wizard")
      jp = JobPost.new title: persisted_jp.title
      jp.valid?
      expect(jp.errors.messages).to(have_key(:title))
      expect(jp.errors.messages[:title]).to(include("has already been taken"))    
    end

    it("requires a description") do 
      job_post = JobPost.new
      job_post.valid?
      expect(job_post.errors.messages).to(have_key(:description))
    end
  end

  
# As per ruby docs, methods that are describe with a
# "." in front are class methods, while those that are 
# describe with a "#" in front are instance methods.
  describe ".search" do
   it("should return all job posts containing a string") do
     # Given 
     # 3 job posts in the db 
     job_post_a = JobPost.create(title: "Software Engineer", description:"Awesome job")
     job_post_b = JobPost.create(title: "Electrical Engineer", description:"Awesome job")
     job_post_c = JobPost.create(title: "Mechanical Engineer", description:"can become electrical professor")
     # When 
     result = JobPost.search("electrical")
     # Then 
     # Jobpost b and c are returned
     expect(result).to(eq([job_post_b, job_post_c]))  
    end
   
  end
  
end
