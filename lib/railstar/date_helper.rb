# -*- coding: utf-8 -*-
# Author:: K.Uchima
module Railstar
  module DateHelper
    private
    def _rep_date_select(t, options={})
      if options[:discard_day]
        t.sub(/<\/select>(.+?)<\/select>/m, "</select>年\\1</select>月")
      elsif options[:discard_year]
        t.sub(/<\/select>(.+?)<\/select>/m, "</select>月\\1</select>日")
      else
        t.sub(/<\/select>(.+?)<\/select>(.+?)<\/select>/m, "</select>年\\1</select>月\\2</select>日")
      end
    end
  end
end

module ActionView
  module Helpers
    module DateHelper
      def date_select_jp(object_name, method, options = {}, html_options = {})
        options[:use_month_numbers] = true if options[:use_month_numbers].nil?
        t = date_select(object_name, method, options, html_options)
        _rep_date_select(t, options)
      end
    end

    class FormBuilder
      include Railstar::DateHelper

      def date_select_jp(method, options = {}, html_options = {})
        options[:use_month_numbers] = true if options[:use_month_numbers].nil?
        t = date_select(method, options, html_options)
        _rep_date_select(t, options)
      end
    end
  end
end

ActionView::Base.send(:include, Railstar::DateHelper)
