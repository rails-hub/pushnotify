class Quote < ActiveRecord::Base

  def send_quote
    User.all.each do |f|
      offset = rand(self.count)
      rand_record = self.offset(offset).first
      PushController.push_message_to_user rand_record.title, f, "Quote", f.id
    end
  end

end