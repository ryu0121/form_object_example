def hoge(user)
  puts user
end

m_obj = method(:hoge)

['ryu'].map(&m_obj)

# &m_obj はm_obj にto_proc メソッドを実行する
# Method オブジェクトはto_proc メソッドを持っているため、method(:hoge) はproc オブジェクトになる
# map の内部的には、call(引数)の形でブロックやMethod オブジェクトにする前のメソッドに引数を渡している

# 以下、Form Object で利用するときの例
# class AuthenticateUser
#   private_class_method :new

#   def self.call(user)
#     new(user).send(:call)
#   end

#   def self.to_proc
#     method(:call).to_proc
#   end

#   private

#   def initialize(user)
#     @user = user
#   end

#   def call
#     return false unless @user

#     if BCrypt::Password.new(@user.password_digest == 'master_password'.freeze
#       @user
#     else
#       false
#     end
#   end
# end

# users.map(&AuthenticateUser)

# AuthenticateUser.to_proc が実行される
# AuthenticateUser.method(:call).to_proc が実行される(self は省略可能)
# proc をレシーバにcall メソッドが呼ばれる(method.call(user))
# 実行されるのは、AuthenticateUser.call(uesr)
class Test
  private_class_method :new

  def self.call(user)
    # .send(:call) にしている理由　
    # Test#call がprivate メソッドになっているからレシーバを取れない
    # send 経由にすることによってprivate メソッドも呼べる
    new(user).send(:call)
  end

  def self.to_proc
    method(:call).to_proc
  end

  private

  def initialize(user)
    @user = user
  end

  def call
    puts 'started call'
    puts @user
    puts 'finished call'
  end
end

Test.call('ryu')