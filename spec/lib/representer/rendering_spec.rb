require "spec_helper"

describe Representer::Base do

  it "renders to json" do
    representer = UserRepresenter.new(User.all)
    representer.render(:json).should == '[{"user":{"id":1,"name":"Peter","email":"peter@email.com"}},{"user":{"id":2,"name":"Olivia","email":"olivia@email.com"}},{"user":{"id":3,"name":"Walter","email":"walter@email.com"}},{"user":{"id":4,"name":"Astrid","email":"astrid@email.com"}},{"user":{"id":5,"name":"Broyles","email":"broyles@email.com"}}]'
  end

  it "renders to xml"

end
