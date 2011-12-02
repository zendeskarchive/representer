class MockRecord < Hash

  def initialize(data = {})
    self.update(data)
  end

  def read_attribute(attribute)
    self[:attributes][attribute]
  end

  def custom_method
    read_attribute("name").upcase
  end

end