module Turnip
  module Execute
    def step(description, *extra_args)
      extra_args.concat(description.extra_args) if description.respond_to?(:extra_args)

      matches = methods.map do |method|
        next unless method.to_s.start_with?("match: ")
        send(method.to_s, description.to_s)
      end.compact

      if matches.length == 0
        raise Turnip::Pending, description
      end

      if matches.length > 1
        msg = ['Ambiguous step definitions'].concat(matches.map(&:trace)).join("\r\n")
        raise Turnip::Ambiguous, msg
      end
      #Todo:ファイルパスを解決
      File.open("/Users/nakaji/Documents/ruby/sample_app/taiou.txt","r") do |f|
        f_r = f.readlines
        f_r.each_with_index do |line,index|
          if line.include?(matches[0].expression)
            File.open("/Users/nakaji/Documents/ruby/sample_app/sizen.txt","a") do |file|
              if matches[0].params[0]
                file.puts "    " + f_r[index+1].gsub(/text/, "'" + matches[0].params[0] + "'")
              else
                file.puts "    " + f_r[index+1]
              end
            end
          end
        end
      end
      send(matches.first.method_name, *(matches.first.params + extra_args))
    end
  end
end
