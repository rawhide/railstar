# coding: utf-8
module CodeToHtml

  HTML_FILE = "#{Rails.root}/tmp/code.html"
  CODE_DIR = "#{Rails.root}/resources/code/"

  def self.make
    csv_list = self.list
    details = self.details
    html = csv_list + details

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
    <h2 id='top'>コード一覧</h2><hr /><table border='1'><tr bgcolor='#99ccff'><td>ファイル名</td><td>説明</td></tr>
    HTML
    Dir::entries(CODE_DIR).each do |f|
      file = File.join(CODE_DIR, f)
      next if File::ftype(file) == "directory"
      open(file).each do |csv|
        html << "<tr><td><a href='#" << f << "'>" << f << "</a></td><td>" << csv.sub(/^title,/, "") << "</td></tr>"
        break
      end
    end
    html << "</table>"
    html
  end

  def self.details
    html = ""
    Dir::entries(CODE_DIR).each do |f|
      file = CODE_DIR + "/" + f
      next if File::ftype(file) == "directory"
      html << "<h3 id='" << f << "'>" << f << "</h3>"
      html << "<a href='#top'>▲</a>"
      html << "<table border='1' width='100%'>"
      i = 0
      open(file).each do |csv|
        if i == 0
          html << "<tr bgcolor='#99ccff'><td colspan='6'>" << csv.sub(/^title,/, "") << "</td></tr>"
          html << "<tr bgcolor='#99ccff'><td>バリュー</td><td>キー</td><td>表示用</td><td>表示順</td><td>JISコード</td><td>親バリュー</tr>"
        elsif i == 1 || i == 2
          # void
        else
          c = csv.split(/,/)
          option = c[4].nil? ? "-" : c[4]
          html << "<tr><td>" << c[0].to_s << "</td><td>" << c[1].to_s << "</td><td>" << c[2].to_s << "</td><td>" << c[3].to_s << "</td><td>" << option << "</td></tr>"
        end
        i = i + 1
      end
      html << "</table>"
    end
    html
  end
end
