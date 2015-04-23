require 'benchmark'
require_relative 'find_max_v1.rb'
require_relative 'find_max_v2.rb'
require_relative 'darkbaby.rb'

num_str = "6446244596324843229078078305533238148243457595610064097959970315835394620044646516409032620454667308766070112535955555160680229989500286252226622539872100872302416105709434110191128704346724013992760418612378439673074054716467417303133833479989324088538347664472552686112344808481731868927372215083229647317219996118748397409846299116871832905980576751331154031067675467258052414249268786515658539784087797283254430225516738559744857839790346593677228107810250920532340599028702461521661265848139123620956668142115302563262203131058100229270243443972546177235771575901922165361396698218117762196544134632798344019281433195806240278753690956068334534221301801209699526184573081952418828691913065992595327825797361953847717570643189642012635449388378992525367348027268165242192622365685480779764783099094867745739784700078839985408192532718515628112701900401712514793903958659409788191075200221271750422613550156973413051306931226442159480989353803152189988847966942635373863348225364240926708982725484" 

Benchmark.bm do |bm|
  bm.report("sample".ljust 10) do
    1000.times do
      num_str.each_char.map(&:to_i).each_cons(5).max.join.to_i
    end
  end
  
  bm.report("v1".ljust 10) do
    1000.times do
      find_max(num_str, 5)
    end
  end
  
  bm.report("v2".ljust 10) do
    1000.times do
      FindMax.new(num_str, 5).search
    end
  end
  
  bm.report("darkbaby".ljust 10) do
    1000.times do
      GreatestDigits.execute(num_str, 5)
    end
  end
  
end