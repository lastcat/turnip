
module Turnip
  module Define
    #rspecで直接呼ばれてる
    def step(method_name=nil, expression, &block)

      #TODO: ファイルパス修正する
      n_phrase = File.read(block.to_s.split("@")[1].split(":")[0]).split("\n")[block.to_s.split("@")[1].split(":")[1].chop.to_i-1]
      s_phrase =
      File.read(block.to_s.split("@")[1].split(":")[0]).split("\n")[block.to_s.split("@")[1].split(":")[1].chop.to_i]
      File.open(Rails.root.to_s + "/taiou.txt","w") do |f|
        f.puts n_phrase
        f.puts s_phrase
      end

      if method_name and block
        raise ArgumentError, "can't specify both method name and a block for a step"
      end
      step = Turnip::StepDefinition.new(expression, method_name, caller.first, &block)
      send(:define_method, "match: #{expression}") { |description| step.match(description) }
      send(:define_method, expression, &block) if block
    end
  end
end
