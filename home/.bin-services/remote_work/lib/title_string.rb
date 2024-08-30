module RemoteWork
  class TitleString < String
    def self.from_str(str)
      new(str.downcase.gsub!(/[^0-9A-Za-z]/, "-"))
    end
  end
end
