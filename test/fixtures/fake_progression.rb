require 'xapi/progression'
class FakeProgression < Xapi::Progression
  def slugs
    ['one', 'two', 'three']
  end
end
