RSpec::Matchers.define :have_field do |name|
  match do |obj|
    expect(obj.respond_to?(name)).to be_truthy
    expect(obj.respond_to?("#{name}=")).to be_truthy
  end

  description do
    "have field #{name}"
  end
end

RSpec::Matchers.define :have_read_only_field do |name|
  match do |obj|
    expect(obj.respond_to?(name)).to be_truthy
    expect(obj.respond_to?("#{name}=")).to be_falsey
  end

  description do
    "have read-only field #{name}"
  end
end
