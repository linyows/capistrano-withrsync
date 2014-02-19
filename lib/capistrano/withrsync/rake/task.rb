class Rake::Task
  def delete
    self.clear
    @full_comment = nil
  end
end
