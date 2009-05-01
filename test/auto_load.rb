require "#{File.dirname(__FILE__)}/helpers"
require 'extensions/io'


describe "auto_load" do

  before do
    Object.instance_eval { remove_const(:A) if const_defined?(:A) }
    FileUtils.mkdir('tmp') rescue nil
    @path = File.join( 'tmp', 'b.rb' )
    content =<<-EOF
      module A
        module B
        end
      end
    EOF
    File.write( @path, content )
  end
  
  after do
    FileUtils.rm( File.join( @path ) )
    FileUtils.rmdir( 'tmp' )
  end
  
  specify "allows you to load a file to define a const" do
    module A
      include AutoCode
      auto_create_class :B
      auto_load :B, :directories => ['tmp']
    end
    A::B.class.should == Module
  end
  
  specify "should implement LIFO semantics" do
    module A
      include AutoCode
      auto_create_class :B
      auto_load :B, :directories => ['tmp']
    end
    A::B.class.should == Module
  end

  specify "raises a NameError if a const doesn't match" do
    module A
      include AutoCode
      auto_create_class :B
      auto_load :B, :directories => ['tmp']
    end
    lambda{ A::C }.should raise_error( NameError )
  end

  it "can use a lambda to specify the target file" do
    module A
      include AutoCode
      auto_create_class :B
      auto_load :B, :target => lambda {|cname| "tmp/#{cname.to_s.downcase}.rb" }
    end
    A::B.class.should == Module 
  end

end
