# coding: utf-8
require 'spec_helper'
require 'active_support/core_ext/string'
require 'action_view'
require './lib/railstar/helper'

require 'erb'
include Railstar::Helper
include ERB::Util
include ActionView::Helpers
include ActionView::Helpers::FormHelper
include ActionView::Helpers::RawOutputHelper


describe Railstar::Helper do
  it '改行コードをBRタグに変換できること' do
    text = <<-EOF
abcd
efghi
jklm
EOF
    hbr(text).should == "abcd<br />efghi<br />jklm<br />"
  end
end

describe Railstar::Helper, ".params_to_hidden_tag" do
  let(:helper) { Railstar::Helper }
  subject { helper.params_to_hidden_tag(:user) }

  context 'params is blank' do
    before { helper.stub(:params) { {} } }
    it { should be_blank }
  end

  context 'params is {:user=>{:name => "foo"}}' do
    before do
      helper.stub(:params) do
        {:user => {:name => "foo"}}
      end
    end
    it { should eq '<input id="user_name" name="user[name]" type="hidden" value="foo" />' }
  end

  context 'params is {:user=>{:name => "foo"}} with except :name' do
    before do
      helper.stub(:params) do
        {:user => {:name => "foo"}}
      end
    end
    subject { helper.params_to_hidden_tag(:user, :except => [:name]) }
    it { should be_blank }
  end

  context 'params is {:user=>{:name=>"foo", :profile_attributes=>{:age=>13}}}' do
    before do
      helper.stub(:params) do
        {:user => {:name => "foo", :profile_attributes => {:age => 13}}}
      end
    end
    it do
      result = ['<input id="user_name" name="user[name]" type="hidden" value="foo" />',
                '<input id="user_profile_attributes_age" name="user[profile_attributes][age]" type="hidden" value="13" />'].join
      should eq result
    end
  end

  context 'params is {:user=>{:name=>"foo", :profile_attributes=>{:age=>13}}, :school_attributes=>{:name=>"hoge"} }' do
    before do
      helper.stub(:params) do
        {:user => {:name => "foo", :profile_attributes => {:age => 13},
                                   :school_attributes => {:name => 'hoge'}}}
      end
    end
    it do
      result = ['<input id="user_name" name="user[name]" type="hidden" value="foo" />',
                '<input id="user_profile_attributes_age" name="user[profile_attributes][age]" type="hidden" value="13" />',
                '<input id="user_school_attributes_name" name="user[school_attributes][name]" type="hidden" value="hoge" />'].join
      should eq result
    end
  end
end
