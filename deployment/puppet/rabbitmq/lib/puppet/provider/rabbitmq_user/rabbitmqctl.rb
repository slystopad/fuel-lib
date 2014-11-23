require 'puppet'
Puppet::Type.type(:rabbitmq_user).provide(:rabbitmqctl) do
  
  #TODO: change optional_commands -> commands when puppet >= 3.0
  optional_commands :rabbitmqctl => 'rabbitmqctl'
  defaultfor :feature => :posix

  def self.instances
    rabbitmqctl('list_users').split(/\n/)[1..-2].collect do |line|
      if line =~ /^(\S+)(\s+\S+|)$/
        new(:name => $1)
      else
        raise Puppet::Error, "Cannot parse invalid user line: #{line}"
      end
    end
  end

  def create
    rabbitmqctl('add_user', resource[:name], resource[:password])
    if resource[:admin] == :true
      make_user_admin()
    end
  end

  def destroy
    rabbitmqctl('delete_user', resource[:name])
  end

  def exists?
    out = rabbitmqctl('list_users').split(/\n/)[1..-2].detect do |line|
      line.match(/^#{Regexp.escape(resource[:name])}(\s+\S+|)$/)
    end
  end

  # def password
  # def password=()
  def admin
    match = rabbitmqctl('list_users').split(/\n/)[1..-2].collect do |line|
      line.match(/^#{Regexp.escape(resource[:name])}\s+\[(administrator)?\]/)
    end.compact.first
    if match
      (:true if match[1].to_s == 'administrator') || :false
    else
      raise Puppet::Error, "Could not match line '#{resource[:name]} (true|false)' from list_users (perhaps you are running on an older version of rabbitmq that does not support admin users?)"
    end
  end

  def admin=(state)
    if state == :true
      make_user_admin()
    else
      rabbitmqctl('set_user_tags', resource[:name])
    end
  end

  def make_user_admin
    rabbitmqctl('set_user_tags', resource[:name], 'administrator')
  end

end
erhaps you are running on an older version of rabbitmq that does not support admin users?)"
    end
  end

  def admin=(state)
    if state == :true
      make_user_admin()
    else
      usertags = get_user_tags
      usertags.delete('administrator')
      rabbitmqctl('set_user_tags', resource[:name], usertags.entries.sort)
    end
  end

  def set_user_tags(tags)
    is_admin = get_user_tags().member?("administrator") \
               || resource[:admin] == :true
    usertags = Set.new(tags)
    if is_admin
      usertags.add("administrator")
    end
    rabbitmqctl('set_user_tags', resource[:name], usertags.entries.sort)
  end

  def make_user_admin
    usertags = get_user_tags
    usertags.add('administrator')
    rabbitmqctl('set_user_tags', resource[:name], usertags.entries.sort)
  end

  private
  def get_user_tags
    match = rabbitmqctl('-q', 'list_users').split(/\n/).collect do |line|
      line.match(/^#{Regexp.escape(resource[:name])}\s+\[(.*?)\]/)
    end.compact.first
    Set.new(match[1].split(/, /)) if match
  end
end
