class User < ActiveRecord::Base
  has_one :calendar_list

  # keeping it light, and don't expose access_token
  def as_json(options={})
    super(:only => [:email])
  end
end
