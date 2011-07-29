# coding: utf-8
module DoubleSubmitProtect
  TOKEN_FILED_NAME = 'hidden_submit_token'

  class DoubleSubmitError < StandardError; end

  module Controller
    def check_double_submit
      session[DoubleSubmitProtect::TOKEN_FILED_NAME] ||= {}
      return if params[DoubleSubmitProtect::TOKEN_FILED_NAME].nil?
      if (request.post? || request.put? || request.delete?) && session[DoubleSubmitProtect::TOKEN_FILED_NAME].key?(params[DoubleSubmitProtect::TOKEN_FILED_NAME])
        raise DoubleSubmitError, '二重投稿'
      else
        session[DoubleSubmitProtect::TOKEN_FILED_NAME][params[DoubleSubmitProtect::TOKEN_FILED_NAME]] = params[DoubleSubmitProtect::TOKEN_FILED_NAME]
      end  
    end
  end
end

class ActionController::Base
  include DoubleSubmitProtect::Controller
end

module ActionView::Helpers::FormHelper
  require 'digest/sha1'
  def double_submit_token
    key = Digest::SHA1.hexdigest(Time.now.to_s)
    hidden_field_tag(DoubleSubmitProtect::TOKEN_FILED_NAME, key)
  end
end
