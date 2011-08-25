# coding: utf-8
class String
  require 'iconv'


  def utf8?
    self.encoding.name == 'UTF-8'
  end
end
