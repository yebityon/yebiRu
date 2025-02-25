module BaseModel
  def hello
    'hello from BaseModel'
  end
end

class BaseKlass
  def hello
    'hello from BaseKlass'
  end
end

class BaseKlass
  alias old_hello hello
  def hello
    'hello from BaseKlass_extend ' + old_hello
  end
end

module BaseModel
  alias old_hello hello
  def hello
     'hello from BaseModel_extend ' + old_hello
  end

  def self.static_hello
     'static hello from BaseModel'
  end
end

class ModuleUsedKlassWithInclude
  include BaseModel
  def hello 
     'hello from ModuleUsedKlassWithInclude'
  end
end

class ModuleUsedKlassWithExtend
  extend BaseModel
  def hello 
      'hello from ModuleUsedKlassWithExtend'
  end
end

class ModuleUsedKlassWithPrepend
  prepend BaseModel
  def hello 
     'hello from ModuleUsedKlassWithPrepend'
  end
end

puts ModuleUsedKlassWithExtend.hello # load hello as class method in ModuleUsedKlassWithExtend
# includeはインスタンスメソッドとして読み込まれ、定義されている場合は上書きされない
puts ModuleUsedKlassWithInclude.new.hello # load hello as instance method in ModuleUsedKlassWithInclude
puts ModuleUsedKlassWithPrepend.new.hello # load hello as instance method in ModuleUsedKlassWithPrepend
