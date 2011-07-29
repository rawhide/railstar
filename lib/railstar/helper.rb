module Railstar
  module Helper
    def title(page_title)
      content_for(:title) { page_title }
    end

    def stylesheet(*css)
      content_for(:head) { stylesheet_link_tag(*css) }
    end

    def javascript(*js)
      content_for(:head) { javascript_include_tag(*js) }
    end

    def auto_discovery_rss(rss)
      content_for(:head) do
        %Q(<link rel="alternate" type="application/rss+xml" href="#{rss}" title="RSS 2.0" />)
      end
    end

    def hbr(str)
      str = html_escape(str)
      br(str)
    end

    def br(str)
      str.gsub(/\r\n|\r|\n/, "<br />")
    end

    def url2link(str)
      str.gsub(/(https?:\/\/[-_.!~*'()a-zA-Z0-9;\/?:@&=+$,%#]+)/){"<a href='#{$1}'>#{$1}</a>"}
    end

    def params_to_hidden_tag(object, options={})
      str = ''
      str << hidden_field_tag('back', 1) if options[:back]
      attributes = params[object]
      return str unless attributes
      attributes.each do |method,value|
        next if options[:except] && options[:except].include?(method.to_sym)
        if value.is_a? Hash
          value.each do |k,v|
            if v.is_a? Hash
              v.each do |l,w|
                str << hidden_field_tag("#{object}[#{method}][#{k}][#{l}]", w)
              end
            else
              str << hidden_field_tag("#{object}[#{method}][#{k}]", v)
            end
          end
        else
          str << hidden_field(object, method, :value => attributes[method])
        end
      end
      raw(str)
    end

    def save_action(object, options={})
      if object.new_record?
        {:action => "create"}
      else
        {:action => "update", :id => object}
      end.merge(options)
    end
  end
end
