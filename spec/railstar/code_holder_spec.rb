# -*- coding: utf-8 -*-
require 'spec_helper'

require './lib/railstar/code_holder'

describe Railstar::CodeHolder do
  describe ".'csvファイル名'" do
    before do
      Railstar::CodeHolder.clear
    end

    it "で、そのファイルが存在していれば自身のオブジェクトが返る" do
      Railstar::CodeHolder.prefecture.should be_a(Railstar::CodeHolder)
    end
  
    it "で、そのファイルが存在していなければエラーになる" do
      lambda do
        Railstar::CodeHolder.not_exist_file.should
      end.should raise_error
    end
  end
  
  describe "オブジェクトの保持している生データ" do
    before do
      @data = Railstar::CodeHolder.prefecture.send("data")
    end
    
    it "は、Hashである" do
      @data.should be_a(Hash)
    end
    
    it "は、csvのヘッダの内容を保持していない" do
      @data[:title].should be_nil
    end
    
    it "は、型変換されたcsvのボディの内容を保持している" do
      @data["HOKKAIDO"][:value].should == 1
      @data["HOKKAIDO"][:disp].should == "北海道"
      @data["HOKKAIDO"][:jis].should == 1
      @data["HOKKAIDO"][:position].should == 2
      @data["HOKKAIDO"][:key].should be_nil

      @data["OKINAWA"][:value].should == 47
      @data["OKINAWA"][:disp].should == "沖縄県"
      @data["OKINAWA"][:jis].should == 47
      @data["OKINAWA"][:position].should == 48
      @data["OKINAWA"][:key].should be_nil
    end
    
    it "は、csvのpositionの値をorderに保持している" do
      @data[:order].should == ["HOKKAIDO","AOMORI","IWATE","MIYAGI","AKITA","YAMAGATA","HUKUSHIMA","IBARAKI","TOCHIGI","GUNMA","SAITAMA","CHIBA","TOUKYO","KANAGAWA","NIIGATA","TOYAMA","ISHIKAWA","HUKUI","YAMANASHI","NAGANO","GIHU","SIZUOKA","AICHI","MIE","SHIGA","KYOUTO","OOSAKA","HYOUGO","NARA","WAKAYAMA","TOTTORI","SHIMANE","OKAYAMA","HIROSHIMA","YAMAGUCHI","TOKUSHIMA","KAGAWA","EHIME","KOUCHI","FUKUOKA","SAGA","NAGASAKI","KUMAMOTO","OOITA","MIYAZAKI","KAGOSHIMA","OKINAWA"]
    end
  end  
  
  describe "オブジェクト" do
    before do
      @code = Railstar::CodeHolder.prefecture
    end
    
    it "に、csvファイルのヘッダ部分にかかれているメソッドを叩くと、その値が返る" do
      @code.title.should == 'テストCSVファイル'
    end
    
    it "に、key名を渡すと、その行のvalueが返る" do
      @code.HOKKAIDO.should == 1
    end
    
    it "に、[]を渡すと、その行のvalueが返る" do
      @code["HOKKAIDO"].should == 1
      @code[:HOKKAIDO].should == 1
    end
    
    it "に、disp(key名)とすると、表示名が表示される" do
      @code.disp("HOKKAIDO").should == "北海道"
      @code.disp(:HOKKAIDO).should == "北海道"
    end
   
    it "に、disp(value値)とすると、表示名が表示される" do
      @code.disp(1).should == "北海道"
    end

    it "に、position(key名)とすると、ポジションが返される" do
      @code.position("HOKKAIDO").should == 2
      @code.position(:HOKKAIDO).should == 2
    end

    it "に、position(value値)とすると、ポジションが返される" do
      @code.position(1).should == 2
    end

    it ".to_optで[[disp,value],[disp,value],[disp,value]]の形で返る" do
      @code.to_opt.should == [["北海道",1],["青森県",2],["岩手県",3],["宮城県",4],["秋田県",5],["山形県",6],["福島県",7],["茨城県",8],["栃木県",9],["群馬県",10],["埼玉県",11],["千葉県",12],["東京都",13],["神奈川県",14],["新潟県",15],["富山県",16],["石川県",17],["福井県",18],["山梨県",19],["長野県",20],["岐阜県",21],["静岡県",22],["愛知県",23],["三重県",24],["滋賀県",25],["京都府",26],["大阪府",27],["兵庫県",28],["奈良県",29],["和歌山県",30],["鳥取県",31],["島根県",32],["岡山県",33],["広島県",34],["山口県",35],["徳島県",36],["香川県",37],["愛媛県",38],["高知県",39],["福岡県",40],["佐賀県",41],["長崎県",42],["熊本県",43],["大分県",44],["宮崎県",45],["鹿児島県",46],["沖縄県",47]]
    end

    it 'にdisp_value(disp値)とすると、そのdisp値を持つ値が返る' do
      @code.disp_value("神奈川県").should == 14
    end
  end
  
  describe "が、データをキャッシュする" do
    it "ため、同じメソッドを何度呼んでも、呼ばれるloadメソッドは一度だけである" do
    end
  end
end
