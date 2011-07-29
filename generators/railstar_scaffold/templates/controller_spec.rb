require File.dirname(__FILE__) + '/<%= "../" * (controller_class_path.size + 1) %>spec_helper'

describe <%= controller_class_name %>Controller do
  fixtures :<%= table_name %>
  
  describe "GET 'index'" do
    it "indexテンプレートを使う" do
      get 'index'
      response.should be_success
      response.should render_template(:index)
    end
  end
  
  describe "GET 'show'" do
    it "showテンプレートを使う" do
      get 'show', :id => <%= model_name %>.find(:first).id
      response.should be_success
      response.should render_template(:show)
    end
  end
  
  describe "'new'" do
    it "GETでnewテンプレートを使う" do
      get 'new'
      response.should be_success
      response.should render_template(:new)
    end

    it "POSTでconfirmテンプレートを使う" do
      post 'new'
      response.should be_success
      response.should render_template(:confirm)
    end
  end
  
  describe "POST 'create'" do
    it "一件増えて、showアクションにリダイレクト" do
      lambda do
        post 'create', :<%= file_name %> => <%= file_name %>_params
        response.should be_redirect
        response.should redirect_to(:action => "show", :id => assigns[:<%= file_name %>])
      end.should change(<%= model_name %>, :count).by(1)
    end
  end
      
  
  describe "'edit'" do
    before do
      @<%= file_name %> = <%= model_name %>.find(:first)
    end
    
    it "GETでeditテンプレートを使う" do
      get 'edit', :id => @<%= file_name %>
      response.should be_success
      response.should render_template(:edit)
    end

    it "POSTでconfirmテンプレートを使う" do
      post 'edit', :id => @<%= file_name %>
      response.should be_success
      response.should render_template(:confirm)
    end
  end
  
  describe "'update'" do
    before do
      @<%= file_name %> = <%= model_name %>.find(:first)
    end
    
    it "PUTで件数変わらず、showアクションにリダイレクト" do
      lambda do
        put 'update', :id => @<%= file_name %>, :<%= file_name %> => <%= file_name %>_params
        response.should be_redirect
        response.should redirect_to(:action => "show", :id => @<%= file_name %>)
      end.should_not change(<%= model_name %>, :count)
    end
  end
  
  describe "'destroy'" do
    before do
      @<%= file_name %> = <%= model_name %>.find(:first)
    end
    
    it "GETでdestroyテンプレートを使う" do
      get 'destroy', :id => @<%= file_name %>
      response.should be_success
      response.should render_template(:destroy)
    end
    
    it "DELETEで削除。indexにリダイレクト" do
      lambda do
        delete 'destroy', :id => @<%= file_name %>
        response.should be_redirect
        response.should redirect_to(:action => "index")
      end.should change(<%= model_name %>, :count).by(-1)
    end
  end
  
  def <%= file_name %>_params(options = {})
    {}.merge(options)
  end
end