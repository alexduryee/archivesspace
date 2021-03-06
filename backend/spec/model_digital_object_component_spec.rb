require 'spec_helper'
require 'securerandom'

describe 'DigitalObjectComponent model' do

  def create_digital_object_component
    DigitalObjectComponent.create_from_json(JSONModel(:digital_object_component).
                                            from_hash("ref_id" => SecureRandom.hex,
                                                      "component_id" => SecureRandom.hex,
                                                      "title" => "A new digital object component"),
                                            :repo_id => $repo_id)
  end


  it "Allows digital object components to be created" do
    doc = create_digital_object_component

    DigitalObjectComponent[doc[:id]].title.should eq("A new digital object component")
  end
  
  it "you can resequence children" do
    
    dobj = create(:json_digital_object)
    doc = DigitalObjectComponent.create_from_json( build(:json_digital_object_component, :digital_object => 
                                                         { :ref => dobj.uri }) )
    
    doc_child1 = build(:json_digital_object_component)                                                      
    doc_child2 = build(:json_digital_object_component)                                                      
    
    children = JSONModel(:digital_record_children).from_hash({
      "children" => [doc_child1, doc_child2]
    })
    
    expect {
      doc.add_children(children) 
    }.to_not raise_error
    
    doc = DigitalObjectComponent.get_or_die(doc.id)
    doc.children.all.length.should == 2

    expect {
      DigitalObjectComponent.resequence( doc.repo_id )
    }.to_not raise_error
  
  end


end
