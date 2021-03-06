require "#{File.dirname(__FILE__)}/helpers"

describe "A module that has included AutoCode" do
  
  it "can tell you whether a subconstant has an auto-constructor" do
    module A
      include AutoCode
      auto_create_module :B
    end
    
    A.auto_const?(:B).should be_true
    A.auto_const?(:C).should_not be_true
  end
  
end
