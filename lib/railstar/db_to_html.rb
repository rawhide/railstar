# coding: utf-8
module DbToHtml

  HTML_FILE = "#{Rails.root}/tmp/dbschema.html"

  def self.make
    table_list = self.list
    details = self.details
    html = table_list + details

    File.open(HTML_FILE, 'w') do |f|
      f.puts html
    end
  end

  def self.list
    html = <<-HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <meta http-equiv="Content-Style-Type" content="text/css" />
    <meta http-equiv="Content-Script-Type" content="text/javascript" />
  </head>
  <body>
    updated_at: #{DateTime.now}
    <h2 id='top'>テーブル一覧</h2><hr /><table border='1'><tr><td>論理テーブル名</td><td>物理テーブル名</td></tr>
    HTML

    ActiveRecord::Base.connection.execute("show table status;").each do |r|
      r[17] = "-" if r[17].blank?
      html << '<tr><td>' << r[17] << '</td><td><a href="#' << r[0] << '">' << r[0] << '</a></td></tr>'
    end

    html << "</table>"
    html
  end

  def self.details
    html = ""
    ActiveRecord::Base.connection.execute("show tables;").each do |t|
      html << "<h3 id='" + t.first + "'>" + t.first + "</h3>"
      html << "<a href='#top'>▲</a>"
      html << "<table border='1' width='100%'>"
      html << "<tr bgcolor='#99ccff'>"
      html << "<td>フィールド名</td>"
      html << "<td>タイプ</td>"
      #html = html + "<td>文字コード</td>"
      html << "<td>Null</td>"
      html << "<td>キー</td>"
      html << "<td>デフォルト値</td>"
      html << "<td>説明</td>"
      html << "</tr>"
      ActiveRecord::Base.connection.execute("show full columns from " + t.first + ";").each do |r|
        i = 0
        html << "<tr>"
        r.each do |f|
          if (i==2) or (i==6) or (i==7)
          else
            if f.blank?
              html << '<td>-</td>'
            else
              html << '<td>' + f + '</td>'
            end
          end
          i += 1
        end
        html << "</tr>"
      end
      html << "</table>"
    end
    html
  end
end
